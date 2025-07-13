[中文文档（README_CN.md）](README_CN.md)

# ACLD - Asynchronous Circuit Logic Dataset

## Overview

This project provides a comprehensive dataset of various asynchronous circuit logic cells. It is designed to be a valuable resource for researchers and engineers working on asynchronous circuit design. The project includes a structured dataset of circuit netlists and a complete characterization flow for generating standard cell timing libraries (`.lib` files).

**NOTE:** The current state of the dataset contains the directory structure and empty placeholder files. Users are expected to populate these files with their own circuit data or use the provided structure as a template.

## Directory Structure

The repository is organized into two main directories:

-   `createACLD_scripts/`: Contains the asynchronous circuit logic dataset (`ACLD`).
-   `liberty/`: Contains the characterization flow for generating timing libraries.

### `createACLD_scripts/`

This directory houses the core dataset under the `ACLD/` subdirectory.

-   **`ACLD/`**: The dataset is organized hierarchically by `Repository/Library/Cell`.
    -   **Repository**: Represents the design style or paradigm (e.g., `Bundled-Data`, `Quasi-Delay-Insensitive`).
    -   **Library**: A specific family of logic within the repository (e.g., `Click`, `NCL`).
    -   **Cell**: The individual logic cell directory, containing the following files:
        -   `*.sp`: A SPICE netlist describing the circuit of the cell.
        -   `*_tb.sp`: A SPICE testbench for simulating and verifying the cell.
        -   `*.json`: A file for storing metadata about the cell (e.g., function, properties).

-   **`create_cmds.py`**: A Python script that reads the `celllist.xlsx` file and generates a shell script (`create_files.sh`) to automatically create the directory structure and empty files for the dataset.

-   **`celllist.xlsx`**: An Excel file that defines the list of all cells in the dataset.

### `liberty/`

This directory contains a complete characterization flow using the Cadence Liberate and Variety tools (referred to as `trio_flow`). This flow is intended to take the SPICE netlists from the `ACLD` dataset and generate `.lib` timing and power library files.

Key components of the `liberty/` directory:

-   **`run.csh`**: The main script to launch the characterization process.
-   **`trio_flow/`**: Contains the core characterization flow scripts and configuration.
    -   `scripts/char_scripts/`: Contains the main Tcl scripts for characterization (`char.tcl`, `common.tcl`, etc.).
    -   `config/`: Contains user-configurable settings (`init.tcl`).
    -   `gpdk/`: A placeholder for a generic Process Design Kit (PDK), including process models, netlists for primitive cells, and templates.

## How to Use

### 1. Populate the Dataset

The circuit files (`.sp`, `_tb.sp`, `.json`) in `createACLD_scripts/ACLD/` are currently empty. You need to add your own circuit descriptions and data to these files. You can also define new cells by adding them to `celllist.xlsx` and running the `create_cmds.py` and `create_files.sh` scripts to extend the directory structure.

### 2. Configure the Characterization Flow

Before running the characterization, you need to configure the flow in the `liberty/` directory:

1.  **PDK and Models**: Place your PDK files (SPICE models, etc.) in the appropriate directories (e.g., `liberty/trio_flow/gpdk/process_models/`).
2.  **Cell List**: Edit `liberty/trio_flow/gpdk/cells.tcl` to specify which cells from the dataset you want to characterize.
3.  **Configuration**: Modify the Tcl files in `liberty/trio_flow/config/` and `liberty/trio_flow/gpdk/` to set up the correct PVT (Process, Voltage, Temperature) corners, simulation settings, and other characterization parameters.

### 3. Run Characterization

Once the dataset is populated and the flow is configured, you can run the characterization from the `liberty/trio_flow/` directory.

```bash
cd liberty/trio_flow
./run.csh <char_type> <tag>
```

-   `<char_type>`: Specifies the type of characterization to run. Options include `NOM` (nominal), `LVF` (Liberty Variation Format), `MC` (Monte Carlo), `EM` (electromigration), etc.
-   `<tag>`: An optional tag to create a unique output directory for the results.

The output, including the generated `.lib` files, will be located in a new directory named `char_<process_name>_<char_type>_<tag>/`.

## Contributing

Contributions to this dataset are welcome. You can contribute by:

-   Adding new asynchronous logic cells.
-   Providing SPICE netlists and testbenches for existing empty cells.
-   Improving the characterization flow.
-   Adding documentation.

Please feel free to fork the repository, add your contributions, and submit a pull request.
