set libs_list [lindex $argv 0]
set libraries [exec cat $libs_list]
set outdir [lindex $argv 1]
validate_scaling -dir $outdir $libraries 

