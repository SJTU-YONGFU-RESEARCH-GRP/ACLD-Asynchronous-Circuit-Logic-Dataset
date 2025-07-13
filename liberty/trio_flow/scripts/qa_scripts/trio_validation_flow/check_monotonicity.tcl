set library [lindex $argv 0]
set outdir [lindex $argv 1]

read_library $library
set libname [ALAPI_name]

validate_monotonicity -report $outdir/${libname}_check_monotonicity.txt 
