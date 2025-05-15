# Asynchronous Circuit Logic Dataset (ACLD)

A collection of Asynchronous Circuit Logic sourced from multiple search engines, designed for computer-aided large-scale asynchronous circuit design.

## Dataset Overview

This dataset contains high-quality asynchronous circuit logic from various asynchronous standard cell libraries. For the most up-to-date dataset statistics and analysis, please refer to [DATASET.md](DATASET.md).

## Project Structure

```
ACLD/
├── dataset/                                 # Main dataset directory
│   ├── 1_10.1109-ASYNC.2010.11_ACL/         # #1 circuit logic from DOI (10.1109/ASYNC.2010.11)
│   │   ├── [repoID].json                    # Circuit logic description file
|   │   ├── [repoID].sp                      # Spice netlist file
│   │   ├── [repoID]_tb1.sp                  # Testbench file (transient mode)
│   │   └── [repoID]_tb2.sp                  # Testbench file (DC mode)
│   └── 2_10.1109-ASYNC.2011.11_ACL/         # #2 circuit logic from DOI (10.1109/ASYNC.2010.11)
│       ├── [repoID].json                    # images from Bing search
│       ├── [repoID].sp                      # images from Google search
│       ├── [repoID]_tb1.sp                  # Circuit netlist file
│       └── [repoID]_tb2.sp                  # Circuit netlist file
|       
│   ...
├── scripts/                    # Utility scripts
│   ├── genLiteratureJson.py    # Script for publication imformation collection from IEEE, and LLM-assisted annotation 
│   ├── genLogicJson.py         # Script for circuit logic property extraction
│   └── batch_process.sh        # Shell script for batch dataset processing
│
├── logics.txt              # List of target circuit logics for collection
├── DATASET.md              # Detailed dataset analysis report
├── requirements.txt        # Python package dependencies
└── LICENSE                 # Project license information
```

## Dataset Statistics

For detailed and up-to-date dataset statistics, including:
- ...
- ...
- Latest update date

Please refer to [DATASET.md](DATASET.md).

## Usage

### Dataset requirement (PDF and netlist)

### Dataset Collection & Generation

To scrape literature for ...:
```bash
python scripts/... .py
```

### Dataset Analysis

To analyze the current dataset:
```bash
python3 scripts/dataset_analyzer.py dataset/ --log-level DEBUG --log-file analysis.log --img-dir imgs --output DATASET.md
```

## Dataset Quality

- All circuit logics are verified for completeness
- Json and netlist files are organized by logic type and source
- No empty or corrupted files included

## Contributing

Contributions to expand the dataset are welcome! Please feel free to:
- Add new asynchronous design characteristics
- Improve annotation quality
- Add more circuit logics to existing design characteristics

## License

This dataset is licensed under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).

You are free to:
- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material for any purpose, even commercially

Under the following terms:
- Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made.

For more details, see the [LICENSE](LICENSE) file.

## Contact

For questions and support, please open an issue in the repository. 
