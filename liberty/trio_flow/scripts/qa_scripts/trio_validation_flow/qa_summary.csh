#!/bin/csh -f

if ($#argv != 1 ) then 
    echo "Incorrect command line use . . ."
    echo "Usage: qa_summary.csh <reports dir>" 
    exit
endif

echo "Reports dir is $1 \n"

setenv DIR $1

## Data range check summary
echo "----------------- Data Range Check Summary -----------------" 
echo "Report log : `realpath ${DIR}/data_range*.log `" 
set failed_data_range = `grep 'Failed cell list' ${DIR}/data_range*.log`
set data_range_warnings = `grep 'validate_data_range' ${DIR}/data_range*.log | tail -n 1 | cut -d ":" -f2`
echo $data_range_warnings
echo $failed_data_range
echo "----------------- End Data Range Check Summary ----------------- \n" 

## Data monotonicity summary 
echo "----------------- Data Monotonicity Check Summary -----------------" 
echo "Report log : `realpath ${DIR}/*check_monotonicity.txt `" 
set failed_monotonicity = `grep failed ${DIR}/*check_monotonicity.txt`
echo $failed_monotonicity 
#if ( $failed_monotonicity != "" ) then 
#   echo "Please check data monotonicity log for failing cells"
#endif
echo "----------------- End Data Monotonicity Check Summary ----------------- \n" 

## CCS vs NLDM summary 
echo "----------------- CCS vs NLDM Check Summary -----------------" 
echo "Report log : `realpath ${DIR}/ccs_vs_nldm.txt`"
set ccs_vs_nldm = `grep -A 3 Entries ${DIR}/ccs_vs_nldm.txt | tail -n 5 | cut -d "|" -f6 | cut -d "+" -f1`
echo $ccs_vs_nldm
echo "----------------- End CCS vs NLDM Check Summary ----------------- \n" 

## CCSN check summary 
echo "----------------- CCSN Check Summary -----------------" 
echo "Report log : `realpath ${DIR}/ccsn_check*.log`"
set ccsn_failed = `grep "Number of failing cells" ${DIR}/ccsn_check*log`
echo $ccsn_failed
echo "----------------- End CCSN Check Summary ----------------- \n" 


## LVF check summary 
echo "----------------- LVF Check Summary -----------------" 
echo "Report log : `realpath ${DIR}/*lvf_checks.txt`"
set lvf_failed = `grep -A 3 "Pass%" ${DIR}/*lvf_checks.txt | cut -d "|" -f4 | cut -d "+" -f1 `
echo "$lvf_failed"
echo "----------------- End LVF Check Summary ----------------- \n" 


## Validate LVF summary 
echo "----------------- Validate LVF Summary -----------------" 
echo "Report log : `realpath ${DIR}/validate_lvf*.log`"
set validateLVF = `grep "error\|warning" ${DIR}/validate_lvf*log | tail -n 1 | cut -d ":" -f2`
echo $validateLVF
echo "----------------- End Validate LVF Summary ----------------- \n" 



