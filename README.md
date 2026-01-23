# Asynchronous Circuit Logic Dataset (ACLD)

A comprehensive collection of asynchronous circuit logic designs, featuring 4 pipeline structures and 26 asynchronous design templates based on 6 data channel configurations. The dataset contains 120 asynchronous circuit logic designs, serving as a valuable resource for simulating and evaluating diverse asynchronous design methods.

---

## Table of Contents
- [Dataset Overview](#dataset-overview)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Dataset Statistics](#dataset-statistics)
- [Dataset Quality](#dataset-quality)
- [Scripts Usage](#scripts-usage)
- [Dataset Access and Usage Examples](#dataset-access-and-usage-examples)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## Dataset Overview

This dataset contains high-quality asynchronous circuit logic from various pipeline structures and design templates. It is organized for easy access and analysis.

---

## Quick Start

Clone the repository and explore the dataset:

```bash
# Clone the repository
git clone https://github.com/your-repo/ACLD.git
cd ACLD

# Example: Extract circuit logic properties
python Scripts/genLogicJson.py --input [repoID].sp --output [repoID].json
```

---

## Project Structure

```
ACLD/
├── ACLD/                                 # Main dataset directory
│   ├── 1_10.1109-ASYNC.2010.11_ACL/         # #1 circuit logic from DOI (10.1109/ASYNC.2010.11)
│   │   ├── [repoID].json                    # Circuit logic description file
│   │   ├── [repoID].sp                      # SPICE netlist file
│   │   ├── [repoID]_tb1.sp                  # Testbench file (transient)
│   │   └── [repoID]_tb2.sp                  # Testbench file (DC)
│   ...
│   └── 120_10.1109-ASYNC.1996.494434_ACL/   # #120 circuit logic from DOI (10.1109/ASYNC.1996.494434)
│       ├── [repoID].json                    # Circuit logic description file
│       ├── [repoID].sp                      # SPICE netlist file
│       ├── [repoID]_tb1.sp                  # Testbench file (transient)
│       └── [repoID]_tb2.sp                  # Testbench file (DC)
│   ...
├── Scripts/                    # Utility scripts
│   ├── genLiteratureJson.py    # Publication information collection and parsing
│   ├── genLogicJson.py         # Circuit logic property extraction
│   └── getMetadata.py          # Publication metadata collection from IEEE
├── Logic.txt                   # List of target circuit logics for collection
├── README.md                   # Dataset documentation and analysis report
└── LICENSE                     # Project license information
```

---

## Dataset Statistics

| Item                    | Count |
|-------------------------|-------|
| Pipeline Structures     | 4     |
| Design Templates        | 26    |
| Data Channel Configs    | 6     |
| Total Circuit Logics    | 120   |

For a summary of asynchronous circuit logic, see [Logic.txt](Logic.txt).

---

## Dataset Quality

- All circuit logics are verified for completeness.
- JSON and netlist files are organized by logic type and source.
- No empty or corrupted files are included.

---

## Scripts Usage

### Dataset Access Script

- **usage_examples.py**: Comprehensive examples demonstrating how to access and use the ACLD dataset with the ACLDDataset class.
  - Features: Dataset access, batch processing, filtering, DataFrame analysis, SPICE simulation
  - Example: `python Scripts/usage_examples.py`

### Dataset Generation Scripts

- **genLiteratureJson.py**: Collects and parses publication information.
- **genLogicJson.py**: Extracts circuit logic properties from SPICE netlists.
- **getMetadata.py**: Retrieves publication metadata from IEEE.

> **Note:** Scripts require Python 3.x. The main usage_examples.py provides interactive examples of all ACLD functionality.

---

## Prerequisites

Before running the scripts, ensure your environment is properly configured:

### Python Environment Setup
```bash
# Activate conda environment (if using conda)
conda activate your_python3_env

# Verify Python version
python --version  # Should be 3.x
```

### Cadence Spectre Setup (for actual simulations)
```bash
# Source Cadence environment (required for Spectre simulations)
source license.sh

# Verify Spectre is available
which spectre
```

## Dataset Access and Usage Examples

### 1. Accessing Dataset Files

Each circuit logic is stored in its own directory with the naming convention: `{id}_{doi}_ACL/`

```python
import os
import json

# Example: Access circuit #1
circuit_dir = "ACLD/1_10.1109-ASYNC.2019.00010_ACL"
json_file = os.path.join(circuit_dir, "1_10.1109-ASYNC.2019.00010_ACL.json")
spice_file = os.path.join(circuit_dir, "1_10.1109-ASYNC.2019.00010_ACL.sp")
```

### 2. Reading JSON Metadata

```python
# Load circuit metadata
with open(json_file, 'r', encoding='utf-8') as f:
    circuit_data = json.load(f)

# Access different information
print(f"Title: {circuit_data['publication']['title']}")
print(f"Pipeline Structure: {circuit_data['techniques']['pipelineStructure']}")
print(f"Transistor Count: {circuit_data['circuit']['transistorCount']}")
print(f"Interface Pins: {circuit_data['circuit']['interface']}")
```

### 3. Using SPICE Netlists for Simulation

```python
# Read SPICE netlist
with open(spice_file, 'r') as f:
    spice_content = f.read()

# The SPICE file contains the complete circuit netlist
# Use with your preferred SPICE simulator (Spectre, HSPICE, ngspice, etc.)
print("SPICE netlist loaded, ready for simulation")
```

### 4. Batch Processing Examples

```python
import glob

# Find all JSON files
json_files = glob.glob("ACLD/*/*.json")

# Analyze transistor counts across all circuits
total_nmos = 0
total_pmos = 0

for json_file in json_files:
    with open(json_file, 'r') as f:
        data = json.load(f)
        total_nmos += data['circuit']['transistorCount']['nmos']
        total_pmos += data['circuit']['transistorCount']['pmos']

print(f"Total NMOS transistors: {total_nmos}")
print(f"Total PMOS transistors: {total_pmos}")
```

### 5. Filtering Circuits by Properties

```python
# Find all QDI circuits
qdi_circuits = []
for json_file in json_files:
    with open(json_file, 'r') as f:
        data = json.load(f)
        if data['techniques']['pipelineStructure'] == 'QDI':
            qdi_circuits.append(data['metadata']['repositoryIdentifier']['id'])

print(f"QDI circuits found: {qdi_circuits}")
```

### 6. Simulation with Testbenches

```python
# Access testbench files
tb1_file = os.path.join(circuit_dir, "1_10.1109-ASYNC.2019.00010_ACL_tb1.sp")
tb2_file = os.path.join(circuit_dir, "1_10.1109-ASYNC.2019.00010_ACL_tb2.sp")

# tb1.sp: Transient analysis (delay and switching energy)
# tb2.sp: DC analysis (static power)
print("Testbench files available for circuit simulation")
```

### 7. Using the ACLDDataset Class

The comprehensive `usage_examples.py` script provides an interactive ACLDDataset class with methods for:

```python
from usage_examples import ACLDDataset

# Initialize dataset accessor
dataset = ACLDDataset()

# Load circuit data
circuit_data = dataset.load_circuit_data(1)

# Get SPICE files and testbenches
spice_file = dataset.get_circuit_spice_file(1)
testbenches = dataset.get_circuit_testbenches(1)

# Run circuit simulation
result = dataset.run_async_circuit_simulation(1, simulator='spectre')
```

### 8. Running the Complete Example Suite

For interactive examples demonstrating all ACLDDataset functionality:

```bash
# Run the comprehensive script (see Prerequisites section for environment setup)
python Scripts/usage_examples.py
```

The script automatically provides:
- Environment validation and setup recommendations
- Dataset access examples with ACLDDataset class
- Batch processing and statistical analysis
- Circuit filtering by pipeline structure and design template
- DataFrame-based analysis (requires pandas)
- SPICE simulation preparation and execution
- Spectre-based timing and power analysis

---

## Contributing

Contributions to expand the dataset are welcome! You can:
- Add new asynchronous design characteristics
- Improve annotation quality
- Add more circuit logics to existing design characteristics

Please open a pull request or issue for discussion.

---

## License

This dataset is licensed under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).

You are free to:
- **Share** — copy and redistribute the material in any medium or format
- **Adapt** — remix, transform, and build upon the material for any purpose, even commercially

Under the following terms:
- **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made.

For more details, see the [LICENSE](https://creativecommons.org/licenses/by/4.0/legalcode) file.

---

## How to Cite

If you use this dataset in your research or publication, please cite the relevant article associated with the dataset. Use the following BibTeX format as a template:

```bibtex
@article{ACLD2025,
  title="{Descriptor: Asynchronous Circuit Logic Dataset (ACLD)}",
  author={Ji, Yuxin and Du, Haochen and Wang, Chao and Hou, Yuting and Li, Yongfu},
  note = {Manuscript under review, IEEE Data Descriptions},
  year = {2025}
}
```

## Contact

For questions and support, please open an issue in the repository. 
