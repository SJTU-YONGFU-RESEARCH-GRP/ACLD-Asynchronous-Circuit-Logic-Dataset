set library [lindex $argv 0]
set outdir [lindex $argv 1]
set tol [lindex $argv 2]

set thresholds [split [exec cat $tol] "\n"]
array unset tolerance *
foreach th $thresholds {
   if { [regexp "^##" $th] } { continue }
   set type [lindex $th 0]
   set min [lindex $th 1]
   set max [lindex $th 2]
   lappend tolerance($type) $min 
   lappend tolerance($type) $max
}

read_library $library
foreach dataType [array names tolerance] {
   set minRange [lindex $tolerance($dataType) 0]
   set maxRange [lindex $tolerance($dataType) 1]
   puts "Checking $dataType for outliers outside min range $minRange and max range $maxRange"
   validate_data_range -type $dataType -min_range $minRange -max_range $maxRange -warn_zero 2 -report $outdir/${dataType}.range.txt
}
