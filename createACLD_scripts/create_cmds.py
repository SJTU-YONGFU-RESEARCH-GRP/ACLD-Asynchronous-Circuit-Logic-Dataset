import pandas as pd

# Load the Excel file
file_path = './celllist.xlsx'  # Change this to the correct path of your Excel file
df = pd.read_excel(file_path, sheet_name='Sheet1')

# Generate the shell script commands
commands = []

for _, row in df.iterrows():
    repository = row['Repository']
    library = row['Library']
    logic_id = row['LogicID']
    logic = row['Logic']
    
    # Define the file paths
    dir_path = f"ACLD/{repository}/{library}/{logic_id}_{logic}"
    json_file = f"{dir_path}/{logic_id}_{logic}.json"
    sp_file = f"{dir_path}/{logic_id}_{logic}.sp"
    tb_sp_file = f"{dir_path}/{logic_id}_{logic}_tb.sp"
    
    # Create the shell command to create the necessary directories and files
    command = f"mkdir -p {dir_path} && touch {json_file} {sp_file} {tb_sp_file}"
    commands.append(command)

# Write the commands to a shell script file
shell_script_path = './create_files.sh'  # Change this to your desired output path
with open(shell_script_path, 'w') as file:
    file.write("#!/bin/bash\n\n")
    for command in commands:
        file.write(command + "\n")

print(f"Shell script has been saved to {shell_script_path}")

