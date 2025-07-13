#!/bin/bash
export MMSIM_ROOT=/eda/cadence/mmsim121
#export OA_HOME=/eda/cadence/ic616_005/oa_v22.43.018/
export CDS_ROOT=/eda/cadence/ic616_005
export X_DIR=/process/xfab
export PATH=$X_DIR/x_all/cadence/xenv:$PATH
export CDSDIR=$CDS_ROOT
export CDSHOME=$CDS_ROOT
export CDS_ROOT=$CDS_ROOT
export CDS_INST_DIR=$CDS_ROOT
export CDS_Netlisting_Mode=Analog
export PATH=$CDS_INST_DIR/tools/bin:$PATH
export PATH=$CDS_INST_DIR/tools/dfII/bin:$PATH
export PATH=$CDS_INST_DIR/tools/plot/bin:$PATH
export PATH=$CDS_INST_DIR/tools/dracula/bin:$PATH
export PATH=$CDS_ROOT/tools/bin:$PATH
export PATH=$CDS_ROOT/tools/dfII/bin:$PATH
export PATH=$CDS_ROOT/tools/dracula/bin:$PATH
export PATH=$CDS_ROOT/tools/plot/bin:$PATH
export PATH=$CDS_ROOT/tools/iccraft/bin:$PATH
export PATH=$MMSIM_ROOT/tools/dfII/bin:$PATH
export PATH=$MMSIM_ROOT/tools/spectre/bin:$PATH
export PATH=$MMSIM_ROOT/tools/ultrasim/bin:$PATH
export PATH=$MMSIM_ROOT/tools/bin:$PATH
#export LM_LICENSE_FILE=/usr/license/license_update.cds:/eda/hspice/Synopsys.dat
export LM_LICENSE_FILE=/usr/license/license_update.cds:/home/yhzhang/opt/Synopsys_2.dat

#export LM_LICENSE_FILE=/home/yhzhang/opt/Synopsys_2.dat

export CDS_LOAD_ENV=CSF
#export HSPICE_HOME=/eda/synopsys/hspice/1303
#export PATH=$HSPICE_HOME/hspice/amd64:$PATH

#export ALTOSHOME=/home/yongfu/proj/mace/liberate19/liberate19
export ALTOSHOME=/eda/cadence/liberate19
export PATH=$ALTOSHOME/bin:$PATH


export ASSURAHOME=/eda/cadence/ASSURA616
export PATH=$ASSURAHOME/tools/assrua/bin:$ASSURAHOME/tools/bin:$PATH

export IUS_PATH=/eda/cadence/incisive13
export CDS_INST_DIR=$IUS_PATH
export CDS_ROOT=/eda/cadence/incisive13
export PATH=$IUS_PATH/tools/bin:$PATH
export LD_LIBRARY_PATH=$IUS_PATH/tools/systemc/gcc/install/lib:$IUS_PATH/tools/lib:$IUS_PATH/tools/verilog/lib:$LD_LIBRARY_PATH
export CDS_AUTO_64BIT=ALL
#export PATH=/eda/cadence/GENUS172/bin:/eda/cadence/GENUS172/tools/bin:/eda/cadence/INNOVUS171/tools/bin:/eda/cadence/INNOVUS171/bin:$PATH
#export OA_HOME=/eda/cadence/INNOVUS171/oa_v22.50.063


export PATH=/eda/cadence/GENUS172/bin:/eda/cadence/GENUS172/tools/bin:/eda/cadence/INNOVUS171/tools/bin:/eda/cadence/INNOVUS171/bin:$PATH
#export OA_HOME=/eda/cadence/INNOVUS171/oa_v22.50.063


export PATH=/eda/hspice/hspice/S-2021.09/hspice/bin:/eda/hspice/scl/2021.03/linux64/bin:$PATH


export PATH=/eda/cadence/IC618/bin:$PATH

