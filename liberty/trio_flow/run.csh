#!/bin/csh -f 

if ( $#argv < 1) then
    echo "Incorrect command line use . . ."
    echo "Usage: run.csh <char_type> <tag>" 
    echo "Where char_type options include NOM|LVF|MC|FMC|UF|EM|AOCV|ICD"
    echo "Where tag options add tag for output directory"
    exit
endif

setenv CHAR_TYPE $1
echo "CHAR_TYPE is $CHAR_TYPE"
setenv TAG "$2"
setenv PROCESS_NAME gpdk

# Modify server setting according to your environment
setenv CDS_BOLT_SERVER sj-liberate1
setenv LIBERATE_TRIO 1
setenv LIBERATE_LORDER TOKENS
setenv CDS_AUTO_64BIT all

# Modfiy build location according to your environment
setenv ALTOSHOME /grid/cic/vfic_flow/FLOW/LIBERATE231/23.12-s064_1/lnx86/
setenv PATH $ALTOSHOME/bin:$PATH

# Creating directory for run
if ( $2 != "") then
    setenv OUT_DIR ${PROCESS_NAME}_${CHAR_TYPE}_${TAG}
else
    setenv OUT_DIR ${PROCESS_NAME}_${CHAR_TYPE}
endif

if (! -d char_${OUT_DIR}) then
	mkdir -p char_${OUT_DIR}
endif  

if (-f char_${OUT_DIR}/char.log) then
	set date = `date +%m%d%C-%R:%S` 
    echo "INFO (trio-flow): Moving char_${OUT_DIR}/char.log to char_${OUT_DIR}/char.log.$date"
    mv char_${OUT_DIR}/char.log char_${OUT_DIR}/char.log.$date
endif

# Determine binary according to CHAR_TYPE 
if ($CHAR_TYPE == NOM || $CHAR_TYPE == UF || $CHAR_TYPE == EM || $CHAR_TYPE == ICD) then
	set binary = liberate
else if ($CHAR_TYPE == LVF || $CHAR_TYPE == AOCV || $CHAR_TYPE == FMC|| $CHAR_TYPE == MC) then
	set binary = variety
else 
	echo "Error: Incorrect char type.  Char type should be NOM, UF, LVF, AOCV, MC, FMC or ICD"
endif

echo "Binary is $binary"
###########################  Main command  #####################################
$binary --trio scripts/char_scripts/char.tcl |& tee char_${OUT_DIR}/char.log

#bsub -q batch  -n 1 -J ${OUT_DIR} -P MPVT:17.1.4:AE:Eval -W "200:00" -R "rusage[mem=20000] select[OSNAME==Linux] span[hosts=1]" \
#-o char_${OUT_DIR}/char.log -e char_${OUT_DIR}/char.log $binary --trio char_scripts/char.tcl
