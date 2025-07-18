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

- **genLiteratureJson.py**: Collects and parses publication information.
  - Example: `python Scripts/genLiteratureJson.py --input input_file --output output_file`
- **genLogicJson.py**: Extracts circuit logic properties from SPICE netlists.
  - Example: `python Scripts/genLogicJson.py --input [repoID].sp --output output.json`
- **getMetadata.py**: Retrieves publication metadata from IEEE.
  - Example: `python Scripts/getMetadata.py --doi 10.1109/ASYNC.2010.11 --output metadata.json`

> **Note:** Scripts require Python 3.x. Install dependencies as needed (see script headers for requirements).

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
