set flow_rev trio_flow_1.6
puts "##################"
puts "INFO (trio-flow): Using Liberate flow $flow_rev"
puts "##################"

set rundir    $env(PWD)
set process   $env(PROCESS_NAME)
set char_type $env(CHAR_TYPE)
set user      $env(USER)
set tag       $env(TAG)

set config_dir    $rundir/config
set scripts_dir   $rundir/scripts/char_scripts
set process_dir   ${rundir}/${process}
set templates_dir ${rundir}/${process}/templates
set model_dir     ${rundir}/${process}/process_models
set outdir        ${rundir}/char_$env(OUT_DIR)

######################################
# source init file containing parameter settings (set_vars) for characterization.
source ${config_dir}/init.tcl
puts "INFO (trio-flow): Sourcing ${config_dir}/init.tcl"

# cell list - simple list of cells - one cell per line
source ${process_dir}/cells.tcl
source ${process_dir}/rechar_cells.tcl
puts "INFO (trio-flow): Sourcing ${process_dir}/cells.tcl and ${process_dir}/rechar_cells.tcl"

set_var set_var_failure_action error
puts "INFO (trio-flow): Sourcing ${process_dir}/pvt.tcl"
source ${process_dir}/pvt.tcl

# pick up part of pvts from full pvt list to char. PVT name should be from pvt.tcl. And that name should exactly match the name in define_pvt.
if {[file exists ${process_dir}/active_pvts.tcl]} {
    source ${process_dir}/active_pvts.tcl
    if {[llength ${active_pvts}] > 0} {set_var bolt_set_active_pvts $active_pvts}
}

## recovery-rechar/remodel flow
set ldb  ${outdir}/ldb.ldb.gz ; # path of ldb from previous session to read-in for recovery flow
if {[file exists $ldb]&& $recovery != 0} {
    if {$recovery == 1} {
        puts "INFO (trio-flow): Trio recovery rechar flow is enabled ..."
        set_var multi_pvt_recovery_flow 1 ; # Do not set this param outside this if-else block for fresh char
        foreach cell $rechar_cells {
            # Do not use below 2 parameters (multi_pvt_rechar_do_preprocessing, multi_pvt_recovery_rechar) for same cell.
            set_var -cell $cell multi_pvt_rechar_do_preprocessing 1
            #set_var -cell $cell multi_pvt_recovery_rechar        1
        }
    } elseif {$recovery == 2} {
        puts "INFO (trio-flow): Trio recovery remodel flow is enabled ..."
        set_var multi_pvt_recovery_flow 0 ; # Do not set this param outside this if-else block for fresh char
        set_var bolt_post_char_command_distribution 1 ; # Do not set this param outside this if-else block for fresh char
    } else {
        puts "Error (trio-flow): Wrong value ($recovery) provided for recoveryFlow. Valid values are: 0 for fresh, 1 for recovery rechar and 2 for recovery remodel\n"
        exit 0
    }
    read_ldb $ldb
    # Placeholder to provide cell/arc level parameter overrides
    # set_var -cell CELLNAME  parameter_name parameter_value
}

# setting up pvt specific model wrapper and sourcing common tcl file
set model_file       ${model_dir}/model_${corner}.sp
set model_stat_file  ${model_dir}/model_${corner}_stat.sp
set model_leak_file  ${model_dir}/model_${corner}_leakage.sp

# sourcing common settings for char
source  ${scripts_dir}/common.tcl
puts "INFO (trio-flow): Sourcing ${scripts_dir}/common.tcl"


if {[packet_slave_cells] == ""} {
   foreach fl [list  $config_dir $scripts_dir] {exec cp -rp $fl $outdir}
}

# reducing the cell list to one specific cell on client
if {[packet_slave_cells] != ""} {set cells [packet_slave_cells]}

# For encrypted model, comment out following line to avoid parse model. Ensure that leafcell definded correctly.
set files $model_file

# source template.tcl file - it could be pvt-specific template or same template shared across all pvts
# For non-auto_index flow, use $scripts/write_template.tcl to generate template. Look for instructions on modifications required for newly generated template in write_template.tcl
source ${templates_dir}/template_common.tcl 
puts "INFO (trio-flow): sourcing ${templates_dir}/template_common.tcl"

# cell level netlist and templates
foreach cell $cells {
  lappend  files  ${netlists_dir}/${cell}.${netlist_extension} 
  puts "INFO (trio-flow): reading $netlists_dir/${cell}.${netlist_extension} .."

  #source cell template tcl file
  source ${templates_dir}/${cell}_template.tcl 
  puts "INFO (trio-flow): sourcing ${templates_dir}/${cell}_template.tcl"
}


# read spice files
read_spice -format spectre  "$files"

# setting simulator path - spectre/ski
set_var extsim_cmd $extsim_cmd
set_var packet_clients $packet_clients
set threads $threads
set_var rsh_cmd $rsh_cmd


if {[file exists $config_dir/custom.tcl]} {source $config_dir/custom.tcl}
# Please note that -cells "must-have" in trio flow in char command 

#set_var -cells {HEAD*} user_arcs_only_mode 0; # enable/disable user_arcs_only for select few cells
set extsim   spectre ; # dont support other vendor simulators
# char commands
if {$::LIBERATE_program == "VARIETY"} {
   set nochar_flag 1
   if {[regexp "LVF" $char_type] || [regexp "AOCV" $char_type]} {
      set nochar_flag 0
      # Variety based Statistical Characterization session
      append charOpts " -skip [list {mpw cin power leakage}] -extsim $extsim" ; puts "INFO (trio-flow): Characterization using $charOpts .." 
      eval char_variation    -cells [list $cells] -thread  $threads $charOpts
   }
   if {[regexp "MC" $char_type]} {
      set nochar_flag 0
      # Variety based MC Characterization session
      set_var rsh_cmd $rsh_cmd_mc
      set charOpts " -monte -monte_trials $mc_trials -skip [list {cin power leakage}] -extsim $extsim" ; puts "INFO (trio-flow): Characterization using $charOpts .." 
      eval char_variation    -cells [list $cells] -thread  $threads $charOpts
   }
      
   if {[regexp "FMC" $char_type]} {
      set nochar_flag 0
      # Variety based MC Characterization session
      #set_var rsh_cmd $rsh_cmd_mc
      #set charOpts " -monte_trials $trials -skip  {mpw} -extsim $extsim" ; puts "INFO (trio-flow): Characterization using $charOpts .." 
      ##eval char_variation    -cells [list $cells] -thread  $threads $charOpts
      char_variation -monte_vvo          -cells  $cells  -thread  1 -extsim spectre

   }
   if {$nochar_flag} {
      puts "Error (trio-flow) : No char_variation in session. Please check your setup..." ; exit 0
   }
} else {
   set nochar_flag 1
   # Unified Flow based Characterization session
   if {[regexp "UF" $char_type]} {
      set nochar_flag 0
      append charOpts " -extsim $extsim" ; puts "INFO (trio-flow): Characterization using $charOpts .." 
      eval char_library -lvf -cells [list $cells] -thread $threads $charOpts
   }
   # Nominal/base Characterization session
   if {[regexp "NOM" $char_type]} {
      set nochar_flag 0
      puts "INFO (trio-flow): (trio-flow): Characterization using options $charOpts .." 
      eval char_library -cells [list $cells] -thread $threads -extsim $extsim $charOpts
   }
   # EM Characterization session
   if {[regexp "EM" $char_type]} {
      set nochar_flag 0
      set charOpts "  -em -extsim $extsim " ; puts "INFO (trio-flow): Characterization using $charOpts .."
      puts "INFO (trio-flow): EM characterization is enabled. Other char option are disabled. EM can't be char-ed along with other format."
      eval char_library      -cells [list $cells] -thread $threads $charOpts
   }
   if {$nochar_flag} {
      puts "Error (trio-flow) : No char_library in session. Please check your setup..." ; exit 0
   }
}

## write ldb/libs 
write_ldb ${outdir}/ldb.ldb.gz

# If first session was for ccsn_char_type=BOTH (ie both CCSN char) then 
# Stage CCSN modeling should be done in separate session using read_ldb+write_library flow
if {$ccsn_model_type == 0} {
   set_var ccsn_use_io_ccb_format    0
   set_var ccs_cap_is_propagating    1
   set_var ccsn_allow_duplicate_default_condition 0
} 

# running various modeling based on characterization session flow
set user_data $process/user_data/user_data.lib
if {![file exists $outdir/libs]} { exec mkdir -p $outdir/libs }
set pvts [get_pvts]
foreach pvt $pvts {
   set filename ${libname}_${pvt} 
   if {[get_var packet_arc_multi_pvt_enable] == 1} {set_pvt $pvt}
   puts "INFO (trio-flow): pvt=$pvt temp=$temp vdd=$vdd pvt_name=$pvt_name"
   # process/modify data in database before libs are written
   source ${scripts_dir}/process_before.tcl
   # liberty model creation (write library) commands
   if {$::LIBERATE_program == "LIBERATE"} {
      if {[regexp "NOM" $char_type]} {
          source ${scripts_dir}/write_library_nom.tcl
      }
      if {[regexp "EM" $char_type]} {
        source ${scripts_dir}/write_library_em.tcl
      } 
      if {[regexp "UF" $char_type]} {
          source ${scripts_dir}/write_library_uf.tcl
      }
   } elseif {$::LIBERATE_program == "VARIETY"} {
      if {[regexp "LVF" $char_type]} {
          source ${scripts_dir}/write_library_lvf.tcl
      }
      if {[regexp "AOCV" $char_type]} {
          source ${scripts_dir}/write_library_aocv.tcl
      }
      if {[regexp "FMC" $char_type]} {
          source ${scripts_dir}/write_library_fmc.tcl
      }
      if {[regexp "MC" $char_type]} {
          source ${scripts_dir}/write_library_mc.tcl
      }
   } else {
        puts "Warning (trio-flow): No write command. Please add write command if you want to write library in this session"
      }
   # Modify/process data. Operate on written library
   source ${scripts_dir}/process_after.tcl
}
