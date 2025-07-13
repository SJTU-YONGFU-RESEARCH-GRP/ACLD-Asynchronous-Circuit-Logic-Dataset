set_var nldm_measure_output_range  0
set_var ccs_rel_tol  0.001
set_var ccs_cap_use_input_transition  2
set_var ccs_cap_enhancement_format_mode 0
set_var ccs_segmentation_effort -1
set_var ccsn_arc_channel_check 4 
set_var ccsn_check_valid_noise_prop 3
set_var ccsn_dc_sweep_mode 4 ; # requires Spectre 181ISR13
set_var ccsn_miller_vin_mode 3
set_var ccsn_default_conditional_check 1
set_var ccsn_part_mode_initialize_internal 1
set_var ccsn_side_ccb_model_mode 1
set_var ccsn_use_output_voltage_level 1
set_var mega_bundle_mode 1
set_var mega_short_circuit_mode 1
set_var mega_enable 2
# mega mode settnig for std cells
# Mega mode settings               (default for std cells)    ; #  for mbff or sync
set_var mega_mode_delay               all                     ; # minimum 
set_var mega_mode_constraint          fanout                  ; # minimum
set_var mega_mode_hidden              fanout                  ; # fanout
set_var extsim_flatten_netlist -1
set_var toggle_leakage_state 0
set_var merge_related_preset_clear  2
set_var process_match_pins_to_ports  1
set_var leakage_cell_attribute  1
set_var constraint_delay_degrade  0.10
set_var constraint_delay_degrade_abstol 2e-12
set_var constraint_glitch_peak_internal  0.2
set_var mpw_criteria  delay
set_var mpw_vector_bin_mode  1
set_var packet_arc_optimize_idle_clients 1
set_var report_nominal_variation_split_runtime 1
set_var variation_unified_model_full_table_cross_params_mode 1  
set_var variation_parallel_mos_res_tol 0.05
set_var variation_parallel_mos_moment_mode 		2 
set_var variation_tran_tend_estimation_mode 		2
set_var variation_random_delay_filter_accum_mode 1 
set_var lvf_enable_minperiod 0
set_var variation_parallel_mos_mode  4
set_var variation_unified_model_mode                    4
