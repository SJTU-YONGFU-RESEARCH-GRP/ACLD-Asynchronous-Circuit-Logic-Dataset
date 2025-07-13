#!/usr/bin/tclsh

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
   puts "#################################################################################"
   puts "Usage: genCellTmpl.tcl <cellMapList> <masterTemplateDir> <CellTemplateoutDir>"
   puts "#################################################################################"
   exit
}
set cellmapfile   [lindex $argv 0]
set mastertmpldir [lindex $argv 1]
set outtmpldir    [lindex $argv 2]

exec mkdir -p $outtmpldir

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
      set celldrive [lindex $line 4]
      set railmap   [lindex $line 5]
#      if {$cellname == "" || $cellmap == "" || $cellfoot == "" || $cellarea == "" || $celldrive == ""} {}
      if {$cellname == "" || $cellmap == "" || $cellfoot == "" || $cellarea == ""} {
#         puts "*Error* Wrong entries at line#$num. Please check, first 5 entries (cellname  cellmap cellfoot cellarea celldrive) should NOT be NULL. Please correct your $cellmapfile & rerun..."
         puts "*Error* Wrong entries at line#$num. Please check, first 5 entries (cellname  cellmap cellfoot cellarea) should NOT be NULL. Please correct your $cellmapfile & rerun..."
         exit
      }
#      set genfile $mastertmpldir/${cellmap}_template.tcl
      set genfile $mastertmpldir/${cellmap}.tcl
      if {![file exists $genfile]} {
         puts "*Error* No cell family template file (${cellmap}_template.tcl) exists at $mastertmpldir for cell family $cellmap. Please take corrective action before proceeding.."
         exit
      } else {
         puts "*Info* generating template for cell $cellname using family template $cellmap.tcl ..."
         exec sed -e "s/CELLNAME/$cellname/g" $genfile > /tmp/${cellname}_template.tcl_[pid]
         regsub -all {\.} $celldrive "p" celldrive
         exec sed -e "s/CELLDRIVE/$celldrive/g" /tmp/${cellname}_template.tcl_[pid] > $outtmpldir/${cellname}_template.tcl
#         exec sed -e "s/CELLDRIVE/$celldrive/g" /tmp/${cellname}_template.tcl_[pid] > $outtmpldir/${cellname}.tcl
      }
      if {$railmap != ""} {
         set railfile $mastertmpldir/rail_$railmap.tcl
         if {[file exists $railfile]} {
            puts "*Info* generating rail_$cellname.tcl file having rail info for cell $cellname using family rail_$railmap.tcl file."
            exec sed -e "s/CELLNAME/$cellname/g" $mastertmpldir/rail_$railmap.tcl > $outtmpldir/rail_$cellname.tcl
         } else {
            puts "*Error* No rail_$railmap.tcl file exist for $railmap at $mastertmpldir. Please take corrective action before proceeding.."
            exit
         }
      }
   }
}
close $rd

puts "################################# SUMMARY ########################################"
puts "Done Successfully ...."
puts "#################################################################################"
