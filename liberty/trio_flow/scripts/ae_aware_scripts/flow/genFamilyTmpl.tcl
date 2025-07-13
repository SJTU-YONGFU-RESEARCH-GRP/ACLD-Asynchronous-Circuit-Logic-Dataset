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
   puts "##############################################################"
   puts "Usage: genFamilyTmpl.tcl <cellMapfile> <refdir> <outdir>"
   puts "##############################################################"
   exit
}

set cellmap [lindex $argv 0]
set refdir [lindex $argv 1]
set outdir [lindex $argv 2]
exec mkdir -p $outdir
set num 0
set ok 0
set err 0

array set genOnce {}
set rd [open $cellmap r]
while {[gets $rd line] >= 0} {
   incr num
   # ignoring all lines starting with # and blank lines
   if {![regexp {(^[ ]*#)} $line] && ![regexp {(^[ ]*$)} $line]} {
      set cellname  [lindex $line 0]
      set cellmap   [lindex $line 1]
      if {$cellname == "" || $cellmap == ""} {
         incr err
         puts "Error : entry at line#$num is ignored.. please check (first two entries should not be NULL & rest entries are ignored) ..."
         continue
      }
      if {[lsearch [array names genOnce] $cellmap] != -1} {continue}
      set genOnce($cellmap) 1

      puts "Info : generating template for cell family $cellmap using cell $cellname ..."
      exec sed -e "s/$cellname/CELLNAME/g" $refdir/${cellname}_template.tcl > $outdir/${cellmap}.tcl
      set rc [catch {exec -ignorestderr grep $cellname   $refdir/pvt_common.tcl >> $outdir/${cellmap}.tcl} msg ]
      exec sed -i "s/-cells \{\.\*\} -type/-cells CELLNAME -type/" $outdir/${cellmap}.tcl
      exec sed -i "s/$cellname/CELLNAME/" $outdir/${cellmap}.tcl
      exec sed -i "s/delay_template_\\wx\\w/delay_template/" $outdir/${cellmap}.tcl
      exec sed -i "s/power_template_\\wx\\w/power_template/" $outdir/${cellmap}.tcl
      exec sed -i "s/mpw_template_\\wx\\w/mpw_template/" $outdir/${cellmap}.tcl
      exec sed -i "s/constraint_template_\\wx\\w/constraint_template/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$VSSG/\$vssg/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$VDDG/\$vddg/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$VDDI/\$vddi/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$VDDO/\$vddo/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$VDD/\$vdd/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$VSS/\$vss/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$VNW/\$vnw/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$VPW/\$vpw/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$BIASNW/\$biasnw/" $outdir/${cellmap}.tcl
      exec sed -i "s/\$BIASPW/\$biaspw/" $outdir/${cellmap}.tcl
      exec sed -i "s/^.*define_max_transition.*$//g" $outdir/${cellmap}.tcl
      incr ok
   }
}
close $rd

puts "################################# SUMMARY ########################################"
puts "Total number of template generated successfully  : $ok"
puts "Total number of cells or lines in cellmap file    : $num"
puts "Number of errors reported, pleae check screen log : $err"
puts "#################################################################################"

