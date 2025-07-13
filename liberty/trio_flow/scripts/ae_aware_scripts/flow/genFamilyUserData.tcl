# runs on Liberate

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
   puts "Usage: genFamilyUserData.tcl <cellMapfile> <reflib> <outdir>"
   puts "##############################################################"
   exit
}

set cellmap [lindex $argv 0]
set reflib [lindex $argv 1]
set outdir [lindex $argv 2]
exec mkdir -p $outdir
set num 0
set ok 0
set err 0

array set genOnce {}
read_library $reflib
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
      write_userdata_library -cells $cellname \
      -include_attributes {default library_features interface_timing default_inout_pin_cap default_input_pin_cap default_leakage_power_density nextstate_type isolation_cell_data_pin isolation_cell_enable_pin always_on is_isolation_cell driver_type max_fanout inverted_output always_on is_isolation_cell isolation_cell_data_pin isolation_cell_enable_pin retention_cell retention_pin state_function function clock_gate_enable_pin clock_gate_test_pin input_map members related_bias_pin related_power_pin related_ground_pin input_signal_level output_signal_level user_function_class antenna_diode_type antenna_diode_related_ground_pins is_decap_cell sec_class sec_cell_type sec_pin_type sec_pdt_pin_type define sec_default_connection_class sec_default_delay_calculation sec_default_multi_vdd_new_kit sec_default_power_class valid_location qc_bias_cell_type physical_connection user_function_class power_down_function is_lvf_hold is_lvf_setup is_lvf_recovery is_lvf_removal } \
      -include_groups {default bundle test_cell ff_bank ff latch statetable pin sec_pdt_pin pg_pin} \
         -exclude_attributes {default} \
         -exclude_groups {default} \
      $outdir/${cellmap}_userdata.lib

      set genOnce($cellmap) 1

      puts "Info : generating user_data for cell family $cellmap using cell $cellname ..."
      exec sed -e "s/$cellname/CELLNAME/g" $outdir/${cellmap}_userdata.lib > /tmp/ud1
      exec sed -e "s/.* cell_footprint : .*/    cell_footprint : \"CELLFOOTPRINT\";/g" /tmp/ud1 > /tmp/ud2
      exec sed -e "s/.* area : .*/    area : CELLAREA;/g" /tmp/ud2 > $outdir/${cellmap}_userdata.lib
      incr ok
   }
}
close $rd

puts "################################# SUMMARY ########################################"
puts "Total number of user_data generated successfully  : $ok"
puts "Total number of cells or lines in cellmap file    : $num"
puts "Number of errors reported, pleae check screen log : $err"
puts "#################################################################################"

