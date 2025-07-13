# setting default & recommended settings for prameters. 
##### Trio common settings ####
# Characterizationa and modeling options
set charOpts  ""
if {$ccs && $::LIBERATE_program == "LIBERATE"} { append charOpts " -ccs" }
if {$ccsn && $::LIBERATE_program == "LIBERATE"} { append charOpts " -ccsn" }
if {$ccsp && $::LIBERATE_program == "LIBERATE"} { append charOpts " -ccsp" }
if {$ecsm && $::LIBERATE_program == "LIBERATE"} { append charOpts " -ecsm" }
if {$ecsmn && $::LIBERATE_program == "LIBERATE"} { append charOpts " -ecsmn" }
if {$ecsmp && $::LIBERATE_program == "LIBERATE"} { append charOpts " -ecsmp" }

# netlist for EM char is different than rest of char
if {[regexp "EM" $char_type]} {
    set netlists_dir   ${rundir}/${process}/netlists_em
    set netlist_extension dspf
} else {
    set netlists_dir   ${rundir}/${process}/netlists
}
# Determine netlists_sub_dir and templates_sub_dir if set
if {$netlist_sub_dir != ""} { set netlists_dir ${netlists_dir}/${netlist_sub_dir} }
if {$template_sub_dir != ""} { set templates_dir ${templates_dir}/${template_sub_dir} }

# source driver - CAUTION - keep this before foreach for all cells' netlist
# driver: active driver | ramp | predriver_waveform 
if {[regexp "active" $driver_type]} {
   set driver_cell $driver_cell 
   define_cell  -input A  -output Y  $driver_cell
   set_driver_cell -input_use_index $driver_cell
   lappend files ${netlists_dir}/${driver_cell}.${netlist_extension}
   puts "INFO (trio-flow): Using driver cell ${netlists_dir}/${driver_cell}.${netlist_extension}"
}

# driver reuse for active driver 
if {[regexp "ramp" $driver_type]} {
   set_var predriver_waveform 0
}
if {[regexp "predriver" $driver_type]} {
   set_var predriver_waveform 2
   set_var predriver_waveform_ratio 0.3
}

if {[get_var packet_arc_multi_pvt_enable] == 1} {
   set_driver_waveforms_file -mpvt_driver_dir ${rundir}/driver_waveforms
} else {
   set_driver_waveforms_file                  ${rundir}/driver_waveforms
}

set_var extsim_model_include $model_file
puts "INFO (trio-flow): model_file is $model_file"

if {[file exists $model_stat_file]} {
set_var -stage variation extsim_model_include $model_stat_file
puts "INFO (trio-flow): model_stat_file is  $model_stat_file"
}

if {[file exists $model_leak_file]} {
set_var -type leakage extsim_model_include $model_leak_file
puts "INFO (trio-flow): model_leak_file is  $model_leak_file"
}


set_var tmpdir /tmp/$::env(USER)_liberate_$libname
set_var ldb_checkpoint_dir ${outdir}/checkpoint
set_var extsim_deck_dir  ${outdir}/decks
set_var extsim_save_passed none
set_var extsim_save_failed all
set_var supply_define_mode 1
set_var enable_command_history  1
set_var rechar_chksum  md5sum
set_var template_unique_power_mode 1
set_var sim_estimate_duration 1
set_var ldb_precision 6
set_var input_output_voltage 1 ; # set to 0 if user data has input output voltage atrribute/group
set_var write_library_mode 1
set_var vector_check_initial_mode 1
set_var vector_save_mode 1
set_var driver_cell_trim_miller 2
set_var measure_cap_active_driver_mode 1
set_var nldm_measure_output_range  0
set_var spice_delimiter  ""
set_var spice_logical_netname_mode  1
set_var rc_floating_cap_rail "0"
set_var adjust_tristate_load_ccsp 1
set_var vector_limit 16384
set_var tran_tend_estimation_mode 2
set_sim_init_condition -method hybrid

# Sensitization vector
#set_var sensitization_vector_mode 1

# Secondry output pin - default load value
set_dependent_load 1e-15

# timing_type combinational
set_var force_timing_type 1

# license/timeout
set_var heartbeat_timeout 1200
set_var spectre_use_char_opt_license 0

# Cap Thresholds
set_var measure_cap_lower_rise  0.2
set_var measure_cap_upper_rise  0.8
set_var measure_cap_lower_fall  0.2
set_var measure_cap_upper_fall  0.8

# CCST
set_var ccs_voltage_tail_tol  0.981
set_var ccs_cap_hidden_pin  2
set_var ccs_cap_duplicate_risefall -1
set_var default_rcvr_cap_groupwise 1

if {$ccs_cap} {
   puts "Info (trio-flow) : New CCS Receiver Cap (C1CN) enabled ..."
   set_var ccs_cap_enhancement_format_mode    1
   set_receiver_cap_thresholds \
    -rise {0.3 0.5 0.6 0.7 0.8 0.9 0.95} \
    -fall {0.7 0.5 0.4 0.3 0.2 0.1 0.05}
} else {
   puts "Info (trio-flow) : Old CCS Receiver Cap (C1C2) enabled ..."
}
# CCSN 
set_var ccsn_dc_static_check_mode 0
set_var ccsn_probe_non_gate 1
set_var ccsn_probe_enable_toggle_res_check 0
set_var ccsn_include_passgate_attr 1
set_var ccsn_pin_stage_lshift 0
set_var ccsn_print_is_needed_if_false_attr_value 1
set_var ccsn_io_mode 0
set_var -pin $async_pins ccsn_part_mode 1
if {$ccsn_char_type == 2} {
   puts "Info (trio-flow) : Both CCSN Char flow is enabled ..."
   set_var ccsn_char_both_formats						1	; # Characterize both stage-based and referenced CCSN formats
   set_var ccsn_char_both_formats_compatibility_mode	1
}
if {$ccsn_char_type != 0} {
   if {$ccsn_char_type == 1} {puts "Info (trio-flow) : Reference CCSN Char flow is enabled ..."}
   set_var ccsn_use_io_ccb_format    1
   set_var ccs_cap_is_propagating    3
   set_var ccsn_input_signal_level_check 1
   set_var ccsn_model_channel_connected_ccbs 2
} else {
   puts "Info (trio-flow) : Old CCSN char flow is enabled ..."
   set_var ccsn_char_both_formats	 0
   set_var ccsn_use_io_ccb_format    0
   set_var ccs_cap_is_propagating    1
   set_var ccsn_allow_duplicate_default_condition 0
}
# CCSP
set_var ccsp_min_pts 15
set_var ccsp_tail_tol 0.02
set_var ccsp_table_reduction 0
set_var ccsp_related_pin_mode  2
set_var ccsp_prune_start_tol  0.1
set_var ccsp_unateness_infer_mode 1
set_var ccsp_rel_tol  0.01
set_var ccsp_meas_supply_cap_enhance_mode 0

# auto-index: no auto_index, scaler based,  geo mean based
if {$autoindex  != "noAI"} {
   append charOpts " -auto_index "
   set_var scale_tran_by_template 1 
   set_var scale_load_by_template 1
}
if {$autoindex  == "gmAI" || $autoindex  == "noAI"} {
   set_var scale_tran_by_template 0 
   set_var scale_load_by_template 0 
}

# max transition for clock pins - used for auto-index
set_var max_transition $max_transition
set_var min_transition $min_transition
set_var min_output_cap $min_output_cap
set clock_max_transition_number [expr 0.5 * [get_var max_transition]]
define_max_transition $clock_max_transition_number {* CK}
define_max_transition $clock_max_transition_number {* CKN}
define_max_transition $clock_max_transition_number {* G}
define_max_transition $clock_max_transition_number {* GN}
define_max_transition $clock_max_transition_number {* ECK}
define_max_transition $clock_max_transition_number {* ECKN}
set_var max_transition_for_outputs [get_var max_transition]
set_var max_transition_include_power 1

set max_transition_factor 1.0
set_var max_transition_attr_limit [expr $max_transition * $max_transition_factor]


# Settings related to sdf_cond
set_var sdf_logic_and  && 
set_var sdf_logic_or   || 
set_var sdf_logic_not   !
set_var logic_and   &
set_var logic_or   +

# ECSM
set_var ecsm_cap_style off
set_var ecsmn_loadcap_mode 2
set_var ecsmn_vtol_mode 2
set_var ecsmn_skip_itt 1

# Spectre options
set_var extsim_cmd_option      "+spice +aps -cp +lorder MMSIM:PRODUCT +lqt 0 +liberate +rcopt=2 +tryhard_reorder -vabsshort"
set_var extsim_deck_header     "simulator lang=spectre\nSetOption1 options reltol=1e-4 rabsshort=1m mdlthresholds=exact solvertype=3\nsimulator lang=spice"
set_var extsim_leakage_option  "method=gear cmin=1e-18 gmin=1e-18 gminfloatdefault=gmindc redefinedparams=ignore rabsshort=1m limit=delta save=nooutput rebuild_matrix=yes weak_convergence_check=0.999 dcauto=2 dcdampsol=yes"
set_var extsim_option          "method=gear cmin=1e-18 gmin=1e-15 gminfloatdefault=gmindc redefinedparams=ignore rabsshort=1m limit=delta save=nooutput rebuild_matrix=yes dcauto=2 dcdampsol=yes"
set_var extsim_ccsn_dc_option  "method=gear cmin=1e-18 gmin=1e-16 gmindc=1e-16 gminfloatdefault=gmindc redefinedparams=ignore rabsshort=1m limit=delta save=nooutput rebuild_matrix=yes dcuseprevic=yes dcauto=2 dcdampsol=yes"
set_var extsim_tran_append     "lteratio=10 ckptperiod=1800 transres=1e-15 errpreset=moderate"
set_var extsim_tend_estimation_mode 2
set_var extsim_monitor_enable 2
set_var alspice_power_subtract_output_load_match_extsim 1



if {$simulator == "SKI"} {
   set extsim spectre
   set_var ski_enable      1
   set_var ski_clean_mode 2
   set_var ski_mdlthreshold_exact 1
   set_var ski_power_subtract_output_load_match_extsim 1
} else {
   set extsim [string tolower $simulator]
}

# Power settings
set_var max_leakage_vector  100000
set_var power_subtract_leakage  4
set_var reset_negative_power  0
set_var subtract_hidden_power  2
set_var subtract_hidden_power_use_default 2
set_var pin_based_power  0
set_var max_hidden_vector 16384
set_var leakage_float_internal_supply  0
set_var reset_negative_leakage_power  1
set_var reset_leakage_current_mode  1
set_var keep_default_leakage_group  1
set_var duplicate_risefall_power  1
set_var leakage_force_tristate_pin  1
set_var power_minimize_switching 1
set_var power_sim_estimate_duration 1
set_var power_multi_vector_mode 3
set_var leakage_expand_state vectors
set_var leakage_merge_state  2        
set_var power_tend_match_tran 1

# Modeling
set_var keep_empty_cells 1
set_var driver_type_model_pad_check 1
set_var leakage_model_internal_pin 0
set_var pin_type_order {internals outputs inputs inouts}
set_var pin_vdd_supply_style    2
set_var force_condition         4
set_var mark_failed_data_replacement "inf"
set_var min_capacitance_for_outputs  1
set_var sdf_cond_equals  "=="
set_var sdf_cond_prefix  "ENABLE"
set_var sdf_cond_style  1
set_var force_unconnected_pg_pin 1
set_var power_model_gnd_waveform_data_mode 1
set_var conditional_expression  separate
set_var define_arc_preserve_when_string 1
set_var power_multi_output_binning_mode 1
set_var disable_method  2
set_var def_arc_msg_level  0
set_var pin_based_signal_level_mode 0
set_var pin_based_signal_level_mode  ""
set_var user_data_override  {area function three_state state_function power_down_function voltage_map}
set_var user_data_quote_attributes {related_bias_pin reference_input restore_condition save_condition related_ccb_node required_condition}
set_var reset_negative_leakage_power_value 1e-30 ; # replace negative leakage value to 1e-24(uW)

set_pin_capacitance  -state  avg  -table  avg  -direction  avg  -side_input  noncontrolling

# Constraint
set_var constraint_vector_equivalence_mode 1
set_var constraint_output_pin  Q
set_var constraint_info  2
set_var constraint_margin  0
set_var constraint_output_load  1e-15
set_var constraint_check_rebound  1
set_var constraint_glitch_hold  1
set_var constraint_glitch_peak  0.20
set_var constraint_vector_mode 4
set_var constraint_probe_multiple merge
set_var mpw_linear_waveform  0
set_var mpw_input_threshold  0.9999
set_var init_clock_period_mode  2
set_var init_constraint_period  40e-09
set_var constraint_search_bound_expand 9
set_var constraint_tran_end_extend 1e-7
set_var constraint_search_time_abstol  0.5e-12
set_var constraint_glitch_peak_mode  2
set_var constraint_glitch_peak_report_inherent  1
set_var nochange_mode 2

###########################
# cell specific settings
###########################
set pktCell [packet_slave_cells]
# Sync cells settings
if {[regexp {(SDFFY.*[0-9]+D.*)} $pktCell]} {
   puts "info (trio-flow) : setting mega mode settings for SYNC cells ($pktCell) ..."
   set_var power_subtract_leakage  2
   # Mega mode settings                     ;#  (default for std cells)    ; #  for mbff or sync
   set_var mega_mode_constraint     minimum ;#     fanout                  ; # minimum
   set_var mega_mode_delay          minimum ;#     all                     ; # minimum 
   set_var mega_mode_hidden         fanout  ;#     fanout                  ; # fanout
}
# MBFF cells settings
if {[regexp {(DFFQ|DFFRPQ|DFFSQ|SDFFQ|SDFFRPQ|SDFFSQ).*(2|4)W.*} $pktCell]} {
   puts "info (trio-flow) : setting mega mode settings for MBFF cells ($pktCell) ..."
   set_var power_subtract_leakage  2
   set_var power_vector_selection_criteria  avg
   set_var write_logic_function  0
   # Mega mode settings                     ;#  (default for std cells)    ; #  for mbff or sync
   set_var mega_mode_constraint     minimum ;#     fanout                  ; # minimum
   set_var mega_mode_delay          minimum ;#     all                     ; # minimum 
   set_var mega_mode_hidden         fanout  ;#     fanout                  ; # fanout
   set_var mega_analysis_mode 3
   set_var mega_short_circuit_mode 2

   # Recommended setting with 19.21-s735_2 to enable ML mode
   set_var trio_ml_arc_mode_1 2
   set_var conditional_expression merge
   set_var max_hidden_vector 64
   set_var max_leakage_vector 64
   set_var worst_vector_selection_mode 1
   set_var ccsn_mega_mbit_hidden_mode 2
   set_var init_constraint_period 50e-09

   # for modeling default groups for cells
   set_var force_default_group 1
   set_default_group -criteria {delay max power avg leakage avg cap avg}
   set_var sdf_cond_style 0
}
if {[regexp "FILL" $pktCell]} {
   set_var -cells $pktCell leakage_expand_state off 
   set_var -cells $pktCell mega_floating_node_reduction 1
   set_var -cells $pktCell vector_check_initial_mode 0
}

define_template -type ecsm \
    -index_1 {0.01 0.05 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 0.95 0.99} ecsm_template

# define leaf cell
source ${process_dir}/define_leafcell.tcl
puts "FLOW INFO: (trio-flow): sourcing source ${process_dir}/define_leafcell.tcl"

#############################
# packet/distribution settings
#############################
set_var packet_mode arc

set_var packet_arc_job_manager  bolt

set_var bolt_client_health_checks      1 
set_var bolt_client_cpu_load_threshold 2.0 ; # Average load per core
set_var bolt_client_cpu_memory_min     5   ; # Min free memory size in GB
set_var bolt_client_cpu_memory_rel     5   ; # Min free memory size in %
set_var bolt_client_disk_space_min     5   ; # Min disk space in GB
set_var bolt_zip_cell_log_files        1

set_var packet_client_simulation_idle_count  0
set_var packet_client_timeout_action  error
set_var packet_client_timeout		  [expr { 1 * 3600 }]
set_var packet_client_log_timeout	  [expr { 1 * 3600 }]
set_var bolt_client_pending_timeout   [expr { 10 * 3600 }] ; # 3600
set_var bolt_connection_timeout       600; # default 100s

# custom priroity for different cells 
# setenv CDS_BOLT_USER_DEFINED_PRIORITIES <prority_list>.. each line has cellname,<priorityNumber>
if {[info exists env(CDS_BOLT_USER_DEFINED_PRIORITIES)] && [file exists $env(CDS_BOLT_USER_DEFINED_PRIORITIES)]} {
   puts "Info (trio-flow) : setting custom cell priority for job packeting for simulations"
   set_var packet_arc_cell_priority_criteria user_defined
}

# custom packets - number of arcs per packet depends on arc type. 
# 100/100 means only 1 search arc in packet, 100/25 means 4 delay arc in a packet, so on.. 
#set_packet_controls \
#   -max_weight 100 \
#   -weight_factor {search 100 delay 25 hidden 10 mpw 10 ccsn 4 leakage 1}

###################
# Variety Settings
###################
set_var packet_arc_xtor_count_based_cell_sort  1
set_var packet_arcs_per_thread				   $arcs_per_thread
set_var packet_cell_max_fets				   1
 
set_var packet_client_timeout		           [expr { 3 * 3600 }]
set_var packet_client_log_timeout	           [expr { 3 * 3600 }]
# sigma variation definitions
set_var variation_constraint_delay_degrade 0.4
set_var constraint_probe_multiple						"separate"	; # Allow LCA for multiple probes

# source define_variation commands
source ${process_dir}/define_variation.tcl
puts "FLOW INFO: (trio-flow): sourcing source ${process_dir}/define_variation.tcl"
  
set_var -type delay variation_unified_model_num_full_table_params  5
set_var -type delay variation_unified_model_full_table_params_mode 1
set_var -type constraint variation_unified_model_num_full_table_params  2
set_var -type constraint variation_unified_model_full_table_params_mode 0
  
set_var variation_random_search_filter_dominant_mode 1
 
set_var define_arc_merge_state 2
set_var variation_constraint_path_delta 1
set_var variation_path_delta_use_bisection_if_no_probe 1 ; # when the result of path_delta charac is zero, retry it with bisection
set_var variation_ecsm_compatibility_mode  1
set_var variation_constraint_search_bound_estimation_redo  1
set_var constraint_random_variation_search_time_abstol 5e-13
   
#set_var mpw_variation 1 ; # enable mpw variation - dont forget to remove -skip_variation {mpw} on char_library -lvf/char_variation

define_variation_method -type delay UM
define_variation_method -type constraint UM

set_var variation_parallel_mos_stack_mode  2

# Need trio license (--trio)
set_var variation_random_parameter_detect_worst_enable  1

set_var derate_comment_start_str "//"
set_var aocv_sigma_factor                     $aocv_sigma_factor

if {$lvf_model_moments == 1} {
	set_var variation_mean_nominal_mode		4
    set_var variation_mean_nominal_model_mode	1 
	set_var variation_mean_nominal_model_mean_shift	1
	set_var variation_mean_nominal_model_skewness 	1
} elseif {$lvf_model_moments == 0} {
    set_var variation_mean_nominal_model_mode 0
}
if {$char_type == "MC"} {
#   set_var extsim_option		"distribute=lsf numprocesses=${mc_cores} method=gear save=nooutput gmin=1e-15 gminfloatdefault=gmindc redefinedparams=ignore limit=delta rabsshort=1m"    
   set_var extsim_option		"method=gear save=nooutput gmin=1e-15 gminfloatdefault=gmindc redefinedparams=ignore limit=delta rabsshort=1m"    
   set_var extsim_monte_option	"sampling=lds seed=4321 savemismatchparams=yes"    
   set_var extsim_monte_thread	${mc_cores}
   set_var monte_percentile	3    
   set_var monte_entries_per_thread	1    
   set_var packet_client_timeout_action  warning 
   #set_var variation_target_sigma	3.0

}
if {$char_type == "FMC"} {
#
set_var packet_client_timeout		  [expr { 48 * 3600 }]
set_var packet_client_log_timeout	  [expr { 48 * 3600 }]
set_var extsim_fmc_option "fmcopt=951"
set_var extsim_monte_option	"sampling=lds seed=4321 fmcmaxbufsize=10 savemismatchparams=yes"  
set_var monte_entries_per_thread 1
set_var vvo_percentile	3.0
set_var fmc_auto_determine_trials 1
set_var fmc_num_tail_samples 10
#set sigma here
set_var monte_carlo_gaussian_truncate 4.0 
	
set_var retry_count 0
#set_var rsh_cmd "/grid/sfi/farm/bin/bsub -cluster sjlsfdsgdpc -q liberate -m liberate_vorm  -n 1 -J TRIO:CLIENT:MNPVT:FMC_test -P MPVT:17.1.4:AE:Eval -W \"200:00\" -R \"rusage\[mem=4000\] select\[OSNAME==Linux\] span\[hosts=1\]\" -o %B/%L -e %B/%L"

}
# EM settings
if {$char_type == "EM"} {
   set_var em_vector_gen_mode_disable_uda 1
   set_var em_min_duty_ratio 0.01
   set_var em_full_swing_check 2
   ## Required changes for EM characterization
   set_var ccs_cap_hidden_pin				0
   set_var predriver_waveform				2
   set_var extsim_flatten_netlist			0
   
   ## EM characterization settings
   set_var em_include_string				$em_include_string
   set_var em_min_duty_ratio				0.001
   set_var em_report_data_usage_mode		1 ; # Use "I limit" and "Current" in the em report to calculate a more accurate EM toggle rate.
   set_var em_tech_file					    $em_tech_file
   set_var em_user_string \
   "emirutil deltaT=10.0
   emirutil autorun=true
   emirutil report=text
   emirutil extendedreport=true
   emirutil powerRailSupplyNets='VDD VPP'
   emirutil powerRailGroundNets='VBB VSS'
   solver method=direct
   "
   ## New EM Max Cap
   #set_var em_maxcap						2
   #set_var em_maxcap_frequency				{1 2.25 3.5 4.75 6}
   #set_var em_maxcap_type					rms 

   set_var em_current_type 1
   set_var em_char_arcs_mode 3
   set_var em_calculation_monitor_rails 0
   set_var em_calculation_include_input 1
   set_var em_freq_mode 1
   set_var em_iacpeak_mode 0
   set_var em_window_estimate_mode 2
}


# Debug flow
if {$debug_simulation == 1} {
   set_var ski_enable 0
   set_var extsim_save_passed all
   set_var extsim_save_failed all
   set_var extsim_deck_dir $rundir/decks
   set_var extsim_flatten_netlist 0
   set_var vector_dump 1
   set_var vector_estimate_dump 1
   set_var bisection_info 4
   set_var variation_static_partition_info 1
}
