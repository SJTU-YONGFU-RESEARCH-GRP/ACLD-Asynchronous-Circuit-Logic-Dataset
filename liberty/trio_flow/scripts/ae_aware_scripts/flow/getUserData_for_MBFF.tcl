###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
# generate set_pin_vdd, set_pin_gnd input_map and user_data for MBFF cells

set libfile [lindex $argv 0]
# spvg - 
#      - is to generate set_pin_vdd and set_pin_gnd for each pin, this could be helpful especially when you have multi-rails cell i.e. bundle pins are driven by different rail compared to regular pins
#      - is also to generate set_attribute commands for input_map attribute for mbff cells
# userdata - is to write skelton lib file with all attributes/groups you want to include. Please double check the list for include_attrs/groups below. 
set step    [lindex $argv 1] ; # spvg | userdata | both

set lib [read_db $libfile]
set pp [open "set_pin_vddgnd.tcl" w]

# attribute and groups to include in user-data
set include_attrs {library_features in_place_swap_mode default_cell_leakage_power default_fanout_load default_inout_pin_cap default_input_pin_cap default_leakage_power_density default_output_pin_cap define qc_derate_constraint_setup qc_derate_setup_mean_shift qc_derate_setup_skewness qc_derate_setup_std_dev qc_derate_constraint_hold qc_derate_hold_mean_shift qc_derate_hold_skewness qc_derate_hold_std_dev qc_derate_delay_slew_sigma_early qc_derate_delay_slew_sigma_late qc_derate_delay_slew_mean_shift qc_derate_delay_slew_skewness qc_derate_delay_slew_std_dev area cell_footprint interface_timing user_function_class qc_ffbits is_lvf_hold is_lvf_setup qc_bias_cell_type table voltage_name pg_type physical_connection clock clocked_on clear preset direction related_ground_pin related_power_pin members nextstate_type input_map internal_node power_down_function clocked_on next_state function signal_type test_output_only state_function direction}
set include_groups {cell bundle pin ff latch ff_bank latch_bank statetable pg_pin test_cell}

if {$step == "spvg" || $step == "both"} {
# generating set_pin_vdd|gnd for mbff cells
foreach lchild [$lib getChildren cell] {
   foreach cchild [$lchild getChildren pin] {
      foreach {k v} [$cchild getAttr {related_power_pin}] {
         puts $pp "set_pin_vdd  -supply_name $v [$lchild getName] [$cchild getName] \$${v}"
      }
      foreach {k v} [$cchild getAttr {related_ground_pin}] {
         puts $pp "set_pin_gnd  -supply_name $v [$lchild getName] [$cchild getName] \$${v}"
      }
      foreach {k v} [$cchild getAttr {input_map}] {
         puts $pp "set_attribute -cells [$lchild getName] -pins [$cchild getName] $k \"${v}\""
      }
   }
   foreach cchild [$lchild getChildren bundle] {
      foreach {k v} [$cchild getAttr {related_power_pin}] {
         foreach member [lindex [$cchild getCAttr members] 1] { 
            puts $pp "set_pin_vdd  -supply_name $v [$lchild getName] $member \$${v}"
         }
      }
      foreach {k v} [$cchild getAttr {related_ground_pin}] {
         foreach member [lindex [$cchild getCAttr members] 1] { 
            puts $pp "set_pin_gnd  -supply_name $v [$lchild getName] $member \$${v}"
         }
         foreach {k v} [$cchild getAttr {input_map}] {
               puts $pp "set_attribute -cells [$lchild getName] -pins [$cchild getName] $k \"\\\"${v}\\\"\""
         }
      }
      foreach pchild [$cchild getChildren pin] {
         foreach {k v} [$pchild getAttr {related_power_pin}] {
            puts $pp "set_pin_vdd  -supply_name $v [$lchild getName] [$pchild getName] \$${v}"
         }
         foreach {k v} [$pchild getAttr {related_ground_pin}] {
            puts $pp "set_pin_gnd  -supply_name $v [$lchild getName] [$pchild getName] \$${v}"
         }
         foreach {k v} [$pchild getAttr {input_map}] {
               puts $pp "set_attribute -cells [$lchild getName] -pins [$pchild getName] $k \"\\\"${v}\\\"\""
         }
      }
   }
}
close $pp
}

if {$step == "userdata" || $step == "both"} {
# generating user-data for MBFF cells
foreach {lak lav} [$lib getAttr] {if {[lsearch $include_attrs $lak] == -1} {$lib delAttr $lak}}
foreach lchild [$lib getChildren] {
   if {[$lchild getHeader] != "cell"} {
      puts "-- 1 [$lchild getHeader] --"
      $lib delGroup $lchild
   } else {
      foreach cchild [$lchild getChildren] {
         foreach {cak cav} [$cchild getAttr] {if {[lsearch $include_attrs $cak] == -1} {$cchild delAttr $cak}}
         if {[lsearch $include_groups [$cchild getHeader]] == -1} {
            puts "-- 2 [$cchild getHeader] --"
            $lchild delGroup $cchild
         } else {
            foreach pchild [$cchild getChildren] {
               foreach {pak pav} [$pchild getAttr] {if {[lsearch $include_attrs $pak] == -1} {$pchild delAttr $pak}}
               if {[lsearch $include_groups [$pchild getHeader]] == -1} {
                  puts "-- 3 [$pchild getHeader] --"
                  $cchild delGroup $pchild
               } else {
                  foreach p2child [$pchild getChildren] {
                     foreach {p2ak p2av} [$p2child getAttr] {if {[lsearch $include_attrs $p2ak] == -1} {$p2child delAttr $p2ak}}
                     if {[lsearch $include_groups [$p2child getHeader]] == -1} {
                        puts "-- 4 [$p2child getHeader] --"
                        $pchild delGroup $p2child
                     }
                  }
               }
            }
         }
      }
   }
}
$lib writeDb user_data.lib
}
