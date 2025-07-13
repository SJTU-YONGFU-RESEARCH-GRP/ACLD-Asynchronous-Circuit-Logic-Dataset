## Update runCmd below for job submission
set runCmd = '/grid/sfi/farm/bin/bsub -cluster sjlsfdsgdpc -q liberate -n 1 -P MPVT:17.1.4:AE:Eval -W 200:00'
set date = `date +%m%d%y-%R:%S`

## Data Range check 
$runCmd -o ${OUTDIR}/data_range_${date}.log -e ${OUTDIR}/data_range_${date}.log ${binary_lv} check_data_range.tcl $LIB $OUTDIR data_range_tolerance.txt 

## Data monotonicity check 
$runCmd -o  ${OUTDIR}/check_monotonicity_${date}.log -e ${OUTDIR}/check_monotonicity_${date}.log ${binary_lv} check_monotonicity.tcl $LIB $OUTDIR

## CCS vs NLDM check 
$runCmd -o  ${OUTDIR}/ccs_vs_nldm_${date}.log -e ${OUTDIR}/ccs_vs_nldm_${date}.log ${binary_lv} compare_ccs_nldm.tcl $LIB $OUTDIR

## CCSN consistency check 
$runCmd -o  ${OUTDIR}/ccsn_check_${date}.log -e ${OUTDIR}/ccsn_check_${date}.log $binary check_ccsn.tcl $LIB

## LVF consistency check 
$runCmd -o  ${OUTDIR}/lvf_check_${date}.log -e ${OUTDIR}/lvf_check_${date}.log ${binary_lv} check_lvf.tcl $LIB $OUTDIR

## Validate LVF 
$runCmd -o  ${OUTDIR}/validate_lvf_${date}.log -e ${OUTDIR}/validate_lvf_${date}.log ${binary_lv} validate_lvf_data.tcl $LIB $OUTDIR
 

