###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
proc custom_compare_diff {
    {ref_val    -float}
    {comp_val   -float}
    {ref_nom    -float}
    {ref_stddev -float}
    {slew       -float}
    {load       -float}
    {load2      -float}
    {index_1_val       -float}
    {index_2_val       -float}
    {index_3_val       -float}
    {table_type -string}
    {timing_type -string}
} {
    set good_data true

    # Lib Time unit = ns
    # Rel in %, 5 = 5%
    set time_scale 1e-09
     
    set delay_abstol [expr 2e-12/$time_scale]
    set delay_reltol 2

    set slew_abstol [expr 2e-12/$time_scale]
    set slew_reltol 2

    set const_abstol [expr 2e-12/$time_scale]
    set const_reltol 2

    set ocv_delay_abstol [expr 2e-12/$time_scale]
    set ocv_delay_reltol 5

    set ocv_trans_abstol [expr 2e-12/$time_scale]
    set ocv_trans_reltol 9

    set ocv_setup_abstol [expr 2e-12/$time_scale]
    set ocv_setup_reltol 10

    set ocv_hold_abstol [expr 2e-12/$time_scale]
    set ocv_hold_reltol 10

    set ocv_mpw_abstol [expr 2e-12/$time_scale]
    set ocv_mpw_reltol 5

    set mns_abstol [expr 2e-12/$time_scale]
    set mns_reltol 2
    set stddev_abstol [expr 2e-12/$time_scale]
    set stddev_reltol 9
    set skew_abstol [expr 2e-12/$time_scale]
    set skew_reltol 5

    set abstol NA ; set reltol NA
    global compare_abstol
    global compare_reltol

    puts "table_type: $table_type timing_type $timing_type"
    set diff [expr {$comp_val-$ref_val}]
    set abs_diff [expr abs($diff)]
    set rel_diff 100
    if {$ref_val != 0} {
	   set rel_diff [expr (100.0*$diff/abs($ref_val))]
    }
    set abs_rel [expr abs($rel_diff)]
    set cond_1 [expr $abs_diff < 0.001]
    set cond_2 [expr $abs_rel < 1]

    # finding table name
    # delay
    if {[string first "delay" $table_type] != -1} {
       set ref_val [expr max($ref_val,$slew/2.0)]
	   set rel_diff [expr (100.0*$diff/abs($ref_val))]
       if {$abs_diff < 0.001} {set rel_diff "0.0"}
       set abstol $delay_abstol
       set reltol $delay_reltol
    }
    if {[string first "trans" $table_type] != -1} {
       if {$abs_diff < 0.001} {set rel_diff "0.0"}
       set abstol $slew_abstol
       set reltol $slew_reltol
    }

    set diff_table_type $table_type
    if {[string first "const" $table_type] != -1} {
       if {[string first "hold" $timing_type] != -1} {
          set diff_table_type [regsub "const" $diff_table_type "hold"]
       } elseif {[string first "setup" $timing_type] != -1} {
          set diff_table_type [regsub "const" $diff_table_type "setup"]
       } elseif {[string first "min_pulse_width" $timing_type] != -1} {
          set diff_table_type [regsub "const" $diff_table_type "mpw"]
       } elseif {[string first "recovery" $timing_type] != -1} {
          set diff_table_type [regsub "const" $diff_table_type "recovery"]
       }
    }
    if {[string first "early" $timing_type] != -1} {
       append diff_table_type "_early"
    } elseif {[string first "late" $timing_type] != -1} {
       append diff_table_type "_late"
    } else {
       append diff_table_type "_late"
    }
    set table_type $diff_table_type
    set found 0
    if {[compare_is_number $ref_nom] && [compare_is_number $ref_val]} {
       set abs_nom [expr abs($ref_nom)]
       if {$table_type == "ocv_delay_early"} {
          set abstol $ocv_delay_abstol ; set found 1
	      set reltol $ocv_delay_reltol
          set rel_diff [expr {100*3*$diff/(abs($abs_nom) - 3*$ref_val + $slew)}]
      } elseif {$table_type == "ocv_delay_late"} {
	     set abstol $ocv_delay_abstol ; set found 1
	     set reltol $ocv_delay_reltol
         set rel_diff [expr {100*3*$diff/(abs($abs_nom) + 3*$ref_val + $slew)}]
      } elseif {$table_type == "ocv_trans_early"} {
	     set abstol $ocv_trans_abstol  ; set found 1
	     set reltol $ocv_trans_reltol
         set rel_diff [expr {100*3*$diff/(abs($abs_nom) - 3*$ref_val)}]
      } elseif {$table_type == "ocv_trans_late"} {
	     set abstol $ocv_trans_abstol ; set found 1
	     set reltol $ocv_trans_reltol
         set rel_diff [expr {100*3*$diff/(abs($abs_nom) + 3*$ref_val)}]
      } elseif {$table_type == "ocv_setup_early" || $table_type == "ocv_setup_late"} {
	     set abstol $ocv_setup_abstol ; set found 1
	     set reltol $ocv_setup_reltol
         set rel_diff [expr {100*3*$diff/(abs($abs_nom) + 3*$ref_val)}]
      } elseif {$table_type == "ocv_recovery_early" || $table_type == "ocv_recovery_late"} {
	     set abstol $ocv_setup_abstol ; set found 1
	     set reltol $ocv_setup_reltol
         set rel_diff [expr {100*3*$diff/(abs($abs_nom) + 3*$ref_val)}]
      } elseif {$table_type == "ocv_hold_early" || $table_type == "ocv_hold_late"} {
	     set abstol $ocv_hold_abstol ; set found 1
	     set reltol $ocv_hold_reltol
         set rel_diff [expr {100*3*$diff/(abs($abs_nom) + 3*$ref_val)}]
      } elseif {$table_type == "ocv_mpw_early" || $table_type == "ocv_mpw_late"} {
	     set abstol $ocv_mpw_abstol ; set found 1
	     set reltol $ocv_mpw_reltol
         set rel_diff [expr {100*3*$diff/(abs($abs_nom) + 3*$ref_val)}]
      } elseif {[string first "mean_shift" $table_type] != -1} {
	     set abstol $mns_abstol ; set found 1
	     set reltol $mns_reltol
         set rel_diff [expr {100*$diff/(abs($abs_nom) +3*$ref_stddev)}]
      } elseif {[string first "stddev" $table_type] != -1} {
	     set abstol $stddev_abstol ; set found 1
	     set reltol $stddev_reltol
         set rel_diff [expr {100*3*$diff/(abs($abs_nom) +3*$ref_stddev)}]
      } elseif {[string first "skewness" $table_type] != -1} {
	     set abstol $skew_abstol ; set found 1
	     set reltol $skew_reltol
         set rel_diff [expr {100*$diff/(abs($abs_nom) + 3*$ref_stddev)}]
      } else {
	     #puts "$table_type"
         #set cond_1 [expr {$abs_diff < $compare_abstol($table_type)}]
         #set cond_2 [expr {$abs_rel < $compare_reltol($table_type)}]
      }
    }

    set abs_rel [expr abs($rel_diff)] 
    set cond_1 [expr {$abs_diff < $abstol}]
    set cond_2 [expr {$abs_rel < $reltol}]

    if {!$cond_1 && !$cond_2} {
        set good_data false
    }
    if {$found} {puts "$table_type / $comp_val / $ref_val / $slew / $abs_nom / $ref_val / $abs_diff / $abstol / $rel_diff / $reltol / $good_data "}
    return [list $diff $rel_diff $good_data]
}

# MAIN

set comp_lib [lindex $argv 1]
set ref_lib [lindex $argv 0]
set fbasename [file rootname [file tail $comp_lib]]
exec mkdir -p $fbasename

set compare_diff_callback custom_compare_diff

#set_var compare_confidence_interval 0

compare_library  -verbose -ocv_over_nominal -report [pwd]/$fbasename/cmp.txt  $ref_lib $comp_lib

   #-report_select_arc_nworst 10 \
