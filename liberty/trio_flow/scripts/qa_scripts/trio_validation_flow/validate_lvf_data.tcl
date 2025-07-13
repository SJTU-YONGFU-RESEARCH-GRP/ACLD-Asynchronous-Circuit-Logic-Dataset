set library [lindex $argv 0]
set outdir [lindex $argv 1]
read_library $library
set libname [ALAPI_name]

validate_lvf_data -report $outdir/${libname}_validate_lvf.txt 

