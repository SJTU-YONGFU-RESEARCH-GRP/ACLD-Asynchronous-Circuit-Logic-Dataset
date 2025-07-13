[English Version (README.md)](README.md)

# ACLD - 异步电路逻辑数据集

## 概述

本项目提供了一个多样化的异步电路逻辑单元数据集，旨在为异步电路设计领域的研究人员和工程师提供有价值的资源。项目包含结构化的电路网表数据集，以及用于生成标准单元时序库（.lib 文件）的完整特征化流程。

**注意：** 当前数据集仅包含目录结构和空的占位文件。用户需自行补充这些文件的电路数据，或将其作为模板使用。

## 目录结构

本仓库主要分为两个核心目录：

-   `createACLD_scripts/`：包含异步电路逻辑数据集（`ACLD`）。
-   `liberty/`：包含用于生成时序库的特征化流程。

### `createACLD_scripts/`

该目录下的 `ACLD/` 子目录为数据集的核心。

-   **`ACLD/`**：数据集按 `Repository/Library/Cell` 层级组织。
    -   **Repository**：代表设计风格或范式（如 `Bundled-Data`、`Quasi-Delay-Insensitive` 等）。
    -   **Library**：某一设计风格下的具体逻辑系列（如 `Click`、`NCL` 等）。
    -   **Cell**：具体的逻辑单元目录，包含以下文件：
        -   `*.sp`：描述该单元电路的 SPICE 网表文件。
        -   `*_tb.sp`：用于仿真和验证的 SPICE 测试平台文件。
        -   `*.json`：存储该单元元数据信息（如功能、属性等）。

-   **`create_cmds.py`**：Python 脚本，读取 `celllist.xlsx` 并生成 shell 脚本（`create_files.sh`），自动创建数据集目录结构和空文件。

-   **`celllist.xlsx`**：定义数据集中所有单元的 Excel 文件。

### `liberty/`

该目录包含基于 Cadence Liberate 和 Variety 工具的完整特征化流程（`trio_flow`）。该流程旨在将 `ACLD` 数据集中的 SPICE 网表转化为 `.lib` 时序与功耗库文件。

`liberty/` 目录的关键组成部分：

-   **`run.csh`**：启动特征化流程的主脚本。
-   **`trio_flow/`**：包含核心特征化脚本与配置。
    -   `scripts/char_scripts/`：主要 Tcl 特征化脚本（如 `char.tcl`、`common.tcl` 等）。
    -   `config/`：用户可配置参数（如 `init.tcl`）。
    -   `gpdk/`：通用工艺设计包（PDK）示例，包括工艺模型、基础单元网表和模板。

## 使用方法

### 1. 填充数据集

`createACLD_scripts/ACLD/` 目录下的电路文件（`.sp`、`_tb.sp`、`.json`）目前为空。您需要将实际的电路描述和数据补充到这些文件中。也可以通过在 `celllist.xlsx` 中添加新单元，并运行 `create_cmds.py` 和 `create_files.sh`，自动扩展目录结构。

### 2. 配置特征化流程

在运行特征化流程前，需在 `liberty/` 目录下进行如下配置：

1.  **PDK 与模型**：将您的工艺包文件（SPICE 模型等）放入相应目录（如 `liberty/trio_flow/gpdk/process_models/`）。
2.  **单元列表**：编辑 `liberty/trio_flow/gpdk/cells.tcl`，指定需要特征化的数据集单元。
3.  **参数配置**：根据需求修改 `liberty/trio_flow/config/` 和 `liberty/trio_flow/gpdk/` 下的 Tcl 文件，设置 PVT（工艺、电压、温度）角、仿真参数等。

### 3. 运行特征化

数据集补充并配置完成后，可在 `liberty/trio_flow/` 目录下运行特征化流程：

```bash
cd liberty/trio_flow
./run.csh <char_type> <tag>
```

-   `<char_type>`：指定特征化类型，如 `NOM`（标称）、`LVF`（Liberty Variation Format）、`MC`（蒙特卡洛）、`EM`（电迁移）等。
-   `<tag>`：可选标签，用于区分输出目录。

输出结果（包括生成的 `.lib` 文件）将位于 `char_<process_name>_<char_type>_<tag>/` 目录下。

## 贡献方式

欢迎为本数据集做出贡献，包括但不限于：

-   添加新的异步逻辑单元。
-   为现有空单元补充 SPICE 网表和测试平台。
-   改进特征化流程。
-   完善文档。

欢迎 fork 本仓库，提交您的贡献并发起 Pull Request。 