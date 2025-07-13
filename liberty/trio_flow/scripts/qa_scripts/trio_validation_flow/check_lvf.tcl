
set library [lindex $argv 0]
set outdir [lindex $argv 1]
read_library $library
set libname [ALAPI_name]

# char_checks to check fatal error
check_lvf_data  -check char_checks -abstol {out_of_bound 20} -reltol {early_late_sigma_ratio 500 delay_trans_sigma_ratio 40 ocv_within_cell 80 ocv_within_cell_table_fail_ratio 0.5} -report_select_arc -report $outdir/${libname}_lvf_checks.txt $library 

