#!/usr/bin/tclsh
#
###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################

if {$argc != 3} {
   puts "###################################################################"
   puts "Usage: genCellUserData.tcl <cellmap> <family_userdata_dir> <outdir>"
   puts "###################################################################"
   exit
}

set cellmapfile  [lindex $argv 0]
set genuddir     [lindex $argv 1]
set outdir       [lindex $argv 2]
exec mkdir -p $outdir
set num 0

set rd [open $cellmapfile r]
while {[gets $rd line] >= 0} {
   incr num
   # ignoring all lines starting with # and blank lines
   if {![regexp {(^[ ]*#)} $line] && ![regexp {(^[ ]*$)} $line]} {
      set cellname  [lindex $line 0]
      set cellmap   [lindex $line 1]
      set cellfoot  [lindex $line 2]
      set cellarea  [lindex $line 3]
      if {$cellname == "" || $cellmap == "" || $cellfoot == "" || $cellarea == ""} {
         puts "*Error* Wrong entries at line#$num. Please check, first 4 entries (cellname  cellmap cellfootprint cellarea) should not be NULL. Please correct your $cellmapfile & rerun..."
         exit
      }

      set genudfile $genuddir/${cellmap}_userdata.lib
      if {![file exists $genudfile]} {
         puts "*Error* No cell family user-data file (${cellmap}_userdata.tcl) exists at $genuddir for family $cellmap. Please take corrective action before proceeding.."
         exit
      } else {
         puts "*Info* generating user_data for cell $cellname using cell family $cellmap ..."
         exec sed -e "s/CELLNAME/$cellname/g" $genudfile > /tmp/ud1
         exec sed -e "s/CELLFOOTPRINT/$cellfoot/g" /tmp/ud1 > /tmp/ud2
         exec sed -e "s/CELLAREA/$cellarea/g" /tmp/ud2 > $outdir/${cellname}_userdata.lib
      }
   }
}
close $rd

puts "################################# SUMMARY ########################################"
puts " Done Successfully"
puts "ATTENTION : if you want to add library level user-data then please create a file header.lib at $outdir"
puts "            a sample is copied at $outdir"
#exec cp $genuddir/header.lib $outdir
puts ""
puts "#################################################################################"

