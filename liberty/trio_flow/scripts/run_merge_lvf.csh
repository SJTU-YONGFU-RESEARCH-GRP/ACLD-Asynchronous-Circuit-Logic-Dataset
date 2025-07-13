#!/bin/csh -f 

if ( $#argv != 3) then
    echo "Incorrect command line use . . ."
    echo "Usage: run.csh <pvt> <nom_lib> <em_lib>" 
    exit
endif

set pvt=$1
set nom_lib=$2
set em_lib=$3

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
set nomfile=`basename $nom_lib`
liberate --trio scripts/char_scripts/merge_lvf.tcl $pvt $nom_lib $lvf_lib |& tee ./logs/log.merge_lvf_$nomfile
