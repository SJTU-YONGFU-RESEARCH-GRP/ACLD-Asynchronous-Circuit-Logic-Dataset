#!/bin/csh -f
 
if ( $#argv != 2 ) then 
    echo "Incorrect command line use . . ."
    echo "Usage: run_library_scaling.csh <list of libraries> <output dir>" 
    exit
endif

echo "List of Libraries $1"

setenv LIB $1

echo "Output dir is $2"

setenv OUTDIR $2
if (! -d $OUTDIR) then
	mkdir $OUTDIR
endif 

source setup.csh

set binary_lv = liberate_lv

## Update runCmd below for job submission
set runCmd = '/grid/sfi/farm/bin/bsub -cluster sjlsfdsgdpc -q liberate -n 1 -P MPVT:17.1.4:AE:Eval -W 200:00'
set date = `date +%m%d%y-%R:%S`

## Scaling check 
$runCmd -o ${OUTDIR}/scaling_check_${date}.log -e ${OUTDIR}/scaling_check_${date}.log $binary_lv validate_scaling.tcl $LIB $OUTDIR


