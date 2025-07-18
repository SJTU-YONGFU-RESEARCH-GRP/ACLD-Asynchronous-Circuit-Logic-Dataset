import os
import re
import json
import shutil  # Add this import
import argparse

"""
genLogicJson.py
Usage:
  python genLogicJson.py --input [repoID].sp --output [repoID].json
If no arguments are provided, processes all .sp files in the 'netlist' directory as before.
"""

def parse_sp_file(file_path):
    """Parse .sp file and extract circuit information"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Print the first 20 lines for debugging
        print("[DEBUG] First 20 lines of file:")
        for i, line in enumerate(content.splitlines()[:20]):
            print(f"[DEBUG] {i+1}: {line}")

        # Preprocess: join lines ending with '\' with the next line
        lines = content.splitlines()
        joined_lines = []
        buffer = ''
        for line in lines:
            if line.rstrip().endswith('\\'):
                buffer += line.rstrip()[:-1] + ' '
            else:
                buffer += line
                joined_lines.append(buffer)
                buffer = ''
        if buffer:
            joined_lines.append(buffer)
        content_joined = '\n'.join(joined_lines)

        # Print all joined lines containing 'subckt' for debugging
        print("[DEBUG] Joined lines containing 'subckt':")
        for l in joined_lines:
            if 'subckt' in l.lower():
                print(f"[DEBUG] {l}")

        # Default result structure
        result = {
            "circuit": {
                "type": "",
                "signalProcessing": "DTDA",
                "stateRetention": "Static",
                "nonRatioed": False,
                "hasClock": False,
                "transistorCount": {
                    "nmos": 0,
                    "pmos": 0
                },
                "interface": {
                    "pgPins": [],
                    "handshakingPins": [],
                    "dataPins": []
                }
            }
        }

        # More robust regex: match any whitespace before .subckt or subckt (with or without dot)
        subckt_lines = re.findall(r'^\s*\.?subckt\s+(.+)$', content_joined, re.IGNORECASE | re.MULTILINE)
        print(f"[DEBUG] subckt_lines found: {subckt_lines}")
        if subckt_lines:
            last_subckt_line = subckt_lines[-1]
            print(f"[DEBUG] Last .subckt line: {last_subckt_line}")
            tokens = last_subckt_line.strip().split()
            print(f"[DEBUG] Tokens: {tokens}")
            if len(tokens) >= 1:
                result["circuit"]["type"] = tokens[0]
                pins = tokens[1:]
                pgPins = []
                handshakingPins = []
                dataPins = []
                for pin in pins:
                    pin_upper = pin.upper()
                    pin_lower = pin.lower()
                    if "VDD" in pin_upper or "VSS" in pin_upper:
                        pgPins.append(pin)
                    elif "req" in pin_lower or "ack" in pin_lower:
                        handshakingPins.append(pin)
                    else:
                        dataPins.append(pin)
                print(f"[DEBUG] pgPins: {pgPins}")
                print(f"[DEBUG] handshakingPins: {handshakingPins}")
                print(f"[DEBUG] dataPins: {dataPins}")
                result["circuit"]["interface"]["pgPins"] = pgPins
                result["circuit"]["interface"]["handshakingPins"] = handshakingPins
                result["circuit"]["interface"]["dataPins"] = dataPins
                if any('clk' in pin_lower or 'clock' in pin_lower for pin in pins):
                    result["circuit"]["hasClock"] = True
            else:
                result["circuit"]["type"] = ""
        else:
            print("[DEBUG] No .subckt line found!")

        # Updated nonRatioed logic: check if W values exist and if there's more than one unique W for PMOS and NMOS respectively
        # This is a heuristic and might need refinement based on actual SPICE dialect / conventions for ratioed logic.
        # For simplicity, original logic is kept but commented out, replaced by a more basic check.
        # w_values = re.findall(r'W=([\d\.eE+-]+)', content, re.IGNORECASE)
        # if len(set(w_values)) > 1: # Simplified: if multiple W values exist, assume non-ratioed (could be more complex)
        #     result["circuit"]["nonRatioed"] = True

        # A more robust check for nonRatioed might involve checking specific transistor types or parameters.
        # For now, setting to False as per original default, unless specific logic is defined.
        # The original logic `len(set(w_values)) == 2` was specific; changing to be more general or default.
        # To enable nonRatioed detection based on W values:
        w_values_nmos = re.findall(r'^mn\S*\s+.*\s+W=([\d\.eE+-]+)', content, re.IGNORECASE | re.MULTILINE)
        w_values_pmos = re.findall(r'^mp\S*\s+.*\s+W=([\d\.eE+-]+)', content, re.IGNORECASE | re.MULTILINE)

        # If there are transistors and more than one unique width for either NMOS or PMOS, consider it nonRatioed.
        # This is still a heuristic.
        if (w_values_nmos and len(set(w_values_nmos)) > 1) or \
           (w_values_pmos and len(set(w_values_pmos)) > 1) :
            result["circuit"]["nonRatioed"] = True


        pmos_count = len(re.findall(r'^mp', content, re.IGNORECASE | re.MULTILINE))
        nmos_count = len(re.findall(r'^mn', content, re.IGNORECASE | re.MULTILINE))
        result["circuit"]["transistorCount"]["pmos"] = pmos_count
        result["circuit"]["transistorCount"]["nmos"] = nmos_count

        return result

    except Exception as e:
        print(f"Error processing file {file_path}: {str(e)}")
        return None

def process_single_file(input_path, output_path):
    parsed_sp_data = parse_sp_file(input_path)
    if parsed_sp_data:
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(parsed_sp_data, f, indent=2, ensure_ascii=False)
        print(f"Processed {input_path} -> {output_path}")
    else:
        print(f"Failed to process {input_path}")

def main():
    parser = argparse.ArgumentParser(description='Extract circuit logic properties from a SPICE netlist.')
    parser.add_argument('--input', type=str, help='Input .sp file')
    parser.add_argument('--output', type=str, help='Output .json file')
    args = parser.parse_args()

    if args.input and args.output:
        process_single_file(args.input, args.output)
        return

    netlist_dir = "netlist"
    literature_json_dir = "literature_json"
    logic_json_dir = "logic_json"
    current_id = 1 # Initialize current_id

    os.makedirs(logic_json_dir, exist_ok=True)

    # Regex to capture ID and DOI from filenames like "1_10.1109-ASYNC.2010.11_ACL.sp" or "1_10.1109-ASYNC.2010.11.sp"
    # Group 1: ID (digits)
    # Group 2: DOI (characters, numbers, '.', '-')
    # Group 3: Optional suffix (like _ACL)
    filename_regex = re.compile(r"(\d+)_([a-zA-Z0-9.-]+)((?:_[a-zA-Z0-9]+)*?)\.sp$", re.IGNORECASE)

    # Recursively walk through netlist_dir and its subdirectories
    for root, dirs, files in os.walk(netlist_dir):
        for sp_filename in files:
            if sp_filename.endswith('.sp'):
                match = filename_regex.match(sp_filename)
                if not match:
                    print(f"Filename format not recognized for {sp_filename}. Skipping.")
                    continue

                id_str = match.group(1)
                doi_filename_segment = match.group(2)
                original_sp_suffix_group = match.group(3) # Capture the optional suffix

                print(f"Processing {sp_filename}: Original_ID='{id_str}', DOI_segment='{doi_filename_segment}'")

                literature_json_filename = f"{doi_filename_segment}.json"
                literature_json_path = os.path.join(literature_json_dir, literature_json_filename)

                if not os.path.exists(literature_json_path):
                    print(f"Literature JSON for DOI '{doi_filename_segment}' ({literature_json_filename}) not found in '{literature_json_dir}'. Skipping {sp_filename}.")
                    continue

                try:
                    with open(literature_json_path, 'r', encoding='utf-8') as f:
                        literature_data = json.load(f)
                except json.JSONDecodeError as e:
                    print(f"Error decoding JSON from {literature_json_path}: {e}. Skipping.")
                    continue
                except Exception as e:
                    print(f"Error reading {literature_json_path}: {e}. Skipping.")
                    continue

                sp_file_path = os.path.join(root, sp_filename)  # Use full path from os.walk
                parsed_sp_data = parse_sp_file(sp_file_path)

                if parsed_sp_data and "circuit" in parsed_sp_data:
                    circuit_info = parsed_sp_data["circuit"]

                    original_suffix_str = original_sp_suffix_group if original_sp_suffix_group else ''

                    # Construct base name for netlist and testbench files using current_id
                    base_name_for_json_entries = f"{current_id}_{doi_filename_segment}{original_suffix_str}"

                    new_netlist_filename = f"{base_name_for_json_entries}_ACL.sp"
                    # Create output subfolder for this entry
                    output_subdir = os.path.join(logic_json_dir, f"{base_name_for_json_entries}_ACL")
                    os.makedirs(output_subdir, exist_ok=True)
                    # Copy the .sp file to the output subfolder with the new name
                    dest_sp_path = os.path.join(output_subdir, new_netlist_filename)
                    try:
                        shutil.copyfile(sp_file_path, dest_sp_path)
                        print(f"Copied {sp_file_path} to {dest_sp_path}")
                        # Also copy as tb1 and tb2
                        dest_tb1_path = os.path.join(output_subdir, f"{base_name_for_json_entries}_ACL_tb1.sp")
                        dest_tb2_path = os.path.join(output_subdir, f"{base_name_for_json_entries}_ACL_tb2.sp")
                        shutil.copyfile(sp_file_path, dest_tb1_path)
                        print(f"Copied {sp_file_path} to {dest_tb1_path}")
                        shutil.copyfile(sp_file_path, dest_tb2_path)
                        print(f"Copied {sp_file_path} to {dest_tb2_path}")
                    except Exception as e:
                        print(f"Error copying {sp_file_path} to output subfolder: {e}")
                    testbenches = [
                        {
                            "id": "tb1",
                            "file": f"{base_name_for_json_entries}_ACL_tb1.sp",
                            "simulator": "Spectre",
                            "type": "Transient",
                            "measurements": ["Delay", "Switching Energy"]
                        },
                        {
                            "id": "tb2",
                            "file": f"{base_name_for_json_entries}_ACL_tb2.sp",
                            "simulator": "Spectre",
                            "type": "DC",
                            "measurements": ["Static Power"]
                        }
                    ]

                    implementation_info = {
                        "netlist": new_netlist_filename, # Use new filename with current_id
                        "testbenches": testbenches
                    }

                    # Preserve existing keys, update/add circuit and implementation
                    literature_data["circuit"] = circuit_info
                    literature_data["implementation"] = implementation_info

                    # Ensure metadata path exists and set the new sequential id
                    if "metadata" not in literature_data:
                        literature_data["metadata"] = {}
                    if "repositoryIdentifier" not in literature_data["metadata"]:
                        literature_data["metadata"]["repositoryIdentifier"] = {}
                    literature_data["metadata"]["repositoryIdentifier"]["id"] = current_id

                    output_filename = f"{current_id}_{doi_filename_segment}_ACL.json" # Use new sequential ID
                    output_path = os.path.join(output_subdir, output_filename)

                    try:
                        with open(output_path, 'w', encoding='utf-8') as f:
                            json.dump(literature_data, f, indent=2, ensure_ascii=False)
                        print(f"Successfully processed and saved to {output_path}")
                        current_id += 1 # Increment current_id for the next file
                    except Exception as e:
                        print(f"Error writing JSON to {output_path}: {e}")
                else:
                    print(f"Could not parse circuit information from {sp_filename}. Skipping update.")

if __name__ == "__main__":
    main() 
