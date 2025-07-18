# Asynchronous Circuit Logic Dataset (ACLD)

A collection of Asynchronous Circuit Logic which comprises 4 pipeline structures and 26 asynchronous design templates based on 6 data channel configuration, containing 120 asynchronous circuit logic designs. It serves as a comprehensive circuit resource for simulating and evaluating diverse asynchronous design methods. 

## Dataset Overview

This dataset contains high-quality asynchronous circuit logic from various asynchronous pipeline structures and design templates. For the most up-to-date dataset statistics, please refer to [README.md](README.md).

## Project Structure

```
ACLD/
├── ACLD/                                 # Main dataset directory
│   ├── 1_10.1109-ASYNC.2010.11_ACL/         # #1 circuit logic from DOI (10.1109/ASYNC.2010.11)
│   │   ├── [repoID].json                    # Circuit logic description file
|   │   ├── [repoID].sp                      # Spice netlist file
│   │   ├── [repoID]_tb1.sp                  # Testbench file (transient)
│   │   └── [repoID]_tb2.sp                  # Testbench file (DC)
|   |    
│   ...
│   └── 120_10.1109-ASYNC.1996.494434_ACL/   # #120 circuit logic from DOI (10.1109/ASYNC.1996.494434)
│       ├── [repoID].json                    # Circuit logic description file
│       ├── [repoID].sp                      # Spice netlist file
│       ├── [repoID]_tb1.sp                  # Testbench file (transient)
│       └── [repoID]_tb2.sp                  # Testbench file (DC)
|       
│   ...
├── Scripts/                    # Utility scripts
│   ├── genLiteratureJson.py    # Script for publication imformation collection and parsing 
│   ├── genLogicJson.py         # Script for circuit logic property extraction
│   └── getMetadata.py          # Script for publication metadata collection from IEEE
│
├── Logic.txt              # List of target circuit logics for collection
├── README.md               # Detailed dataset analysis report
└── LICENSE                 # Project license information
```

## Dataset Statistics

For detailed and up-to-date dataset statistics, including:
- Publication information
- Latest update date
- Circuit logic description file
- Spice netlist file
- Testbench file

For the summary of asynchronous circuit logic, please refer to [Logic.txt](Logic.txt).

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