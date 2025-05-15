import os
import re
import json

def parse_sp_file(file_path):
    """解析.sp文件并提取电路信息"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
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
        
        subckt_lines = re.findall(r'^\.subckt\s+(\w+)\s+(.*)', content, re.IGNORECASE | re.MULTILINE)
        if subckt_lines:
            last_subckt = subckt_lines[-1]
            result["circuit"]["type"] = last_subckt[0]
            
            pins = last_subckt[1].split()
            for pin in pins:
                pin_lower = pin.lower()
                if pin_lower in ['vdd', 'vss', 'gnd']: # Added gnd as a common pgPin
                    result["circuit"]["interface"]["pgPins"].append(pin)
                elif any(x in pin_lower for x in ['ack', 'req', 'en', 'val', 'rdy']): # Broader handshaking terms
                    result["circuit"]["interface"]["handshakingPins"].append(pin)
                else:
                    result["circuit"]["interface"]["dataPins"].append(pin)
            
            if any('clk' in pin.lower() or 'clock' in pin.lower() for pin in pins):
                result["circuit"]["hasClock"] = True
        
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

def main():
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

    for sp_filename in os.listdir(netlist_dir):
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

            sp_file_path = os.path.join(netlist_dir, sp_filename)
            parsed_sp_data = parse_sp_file(sp_file_path)

            if parsed_sp_data and "circuit" in parsed_sp_data:
                circuit_info = parsed_sp_data["circuit"]
                
                original_suffix_str = original_sp_suffix_group if original_sp_suffix_group else ''
                
                # Construct base name for netlist and testbench files using current_id
                base_name_for_json_entries = f"{current_id}_{doi_filename_segment}{original_suffix_str}"

                new_netlist_filename = f"{base_name_for_json_entries}.sp"
                testbenches = [
                    {
                        "id": "tb1",
                        "file": f"{base_name_for_json_entries}_tb1.sp",
                        "simulator": "HSPICE",
                        "type": "Transient",
                        "measurements": ["Forward Delay", "Backward Delay", "Delay", "Switching Energy"]
                    },
                    {
                        "id": "tb2",
                        "file": f"{base_name_for_json_entries}_tb2.sp",
                        "simulator": "HSPICE",
                        "type": "DC",
                        "measurements": ["Leakage Power", "Leakage Current"]
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
                
                output_filename = f"{current_id}_{doi_filename_segment}_ACLD.json" # Use new sequential ID
                output_path = os.path.join(logic_json_dir, output_filename)
                
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
