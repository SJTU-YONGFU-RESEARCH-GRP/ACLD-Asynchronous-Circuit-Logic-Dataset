#!/bin/csh -f 

if ( $#argv != 3) then
    echo "Incorrect command line use . . ."
    echo "Usage: run.csh <lib>" 
    exit
endif

set lib=$1

# Modify server setting according to your environment
setenv CDS_BOLT_SERVER sj-liberate1
setenv LIBERATE_TRIO 1
setenv LIBERATE_LORDER TOKENS
setenv CDS_AUTO_64BIT all
# Modfiy build location according to your environment
setenv ALTOSHOME /grid/cic/vfic_flow/FLOW/LIBERATE231/23.12-s064_1/lnx86/
setenv PATH $ALTOSHOME/bin:$PATH

###########################  Main command  #####################################
mkdir -p ./logs
liberate --trio scripts/qa_scripts/check_lvf.tcl $lib |& tee ./logs/log.check_lvf
liberate --trio scripts/qa_scripts/check_ccsn.tcl $lib|&tee ./logs/log.check_ccsn
