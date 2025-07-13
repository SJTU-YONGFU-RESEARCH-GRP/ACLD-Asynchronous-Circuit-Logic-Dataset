#############################################################################################################################
# Tcl variables in init.tcl
#
# Recommended Liberate version  21.7x
#
# libname                    - library name for liberty file name and liberty header library name
#
# recovery                   - valid value <0|1|2>
#                            - 0: regular fresh char
#                            - 1: recovery rechar. All cells in cell_list_rechar will be re-chared.
#                            - 2: recovery remodel. Remodel library based on existing database
#
#
# extsim_cmd                 - path to Spectre simulator command
#                                  ex: /icd/flow/SPECTRE/SPECTRE191_ZA/ISR12/lnx86/bin/spectre
#
# netlist_extension          - suffix on netlist file names (i.e sp or spf)
#
# packet_clients             - Number of jobs (clients) to run in parallel
#
# arcs_per_thread            - Number of arcs at a time sent to the client
#
# threads                    - Number of Liberate threads to use per client.  Generally set to 1
#
# mem                        - Memory requirement for bsub client command (rsh_cmd)
#
# rsh_cmd                    - String containing bsub command to submit clients to LSF 
#                              Example:  "bsub -cluster sjlsfdsgdpc -q liberate -n $threads -J CLIENT:$pvt:SPVT -P MPVT:17.1.4:AE:Eval -W \"200:00\" -R \"rusage\[mem=$mem\] select\[OSNAME==Linux\] span\[hosts=1\]\" -o %B/%L -e %B/%L"
#
# rsh_cmd                    - String containing bsub command to submit clients to LSF for MC run. 
#
# driver_type                - Set to "ramp" for 2 point pwl input waveform
#                              Set to "predriver" for ccs predriver (multi point pwl) input waveform
#                              Set to "active" to use active driver cell for input waveform (i.e. Buffer cell)
#
# driver_cell                - If driverType = "Active", set to the name of the active driver cell
#
# autoindex                  - Set to "sfAI" for scale factor based auto indexing
#                              Set to "gmAI" for geometric based auto indexing
#                              Set to "noAI" to turn off auto indexing
#
# simulator                  - Set to "SKI" to turn on SKI 
#                              Set to "SPECTRE" to turn off SKI and use stand alone Spectre
#
# ccs                        - 0 to NOT characterize for ccs timing
#                              1 to characterize ccs timing
#
# ccsn                       - 0 to NOT characterize for ccs noise
#                              1 to characterize ccs noise
#
# ccsp                       - 0 to NOT characterize for ccs power
#                              1 to characterize ccs power
#
# ecsm                       - 0 to NOT characterize for ecsm timing
#                              1 to characterize ecsm timing
#
# ecsmn                      - 0 to NOT characterize for ecsm noise
#                              1 to characterize ecsm noise
#
# ecsmp                      - 0 to NOT characterize for ecsm power
#                              1 to characterize ecsm power
# 
# async_pins                 - list of asynchronous pins for ccsn char
#                              creates 'set_var -pin $async_pins ccsn_part_mode 1' setting
#
# ccs_cap                    - 0 to use 2 point ccs receiver cap models
#                              1 to use multi point ccs receiver cap models
#
# ccsn_model_type            - 0 to model stage based ccsn format 
#                            - 1 to model referenced based ccsn format
# 
# lvf_model_moments          - 0 do not model moments (mean shift, std dev, skewness) when generating lvf data
#                            - 1 include moments with lvf data
# 
# mc_cores                   - number of monte carlo cores to use with Variety monte carlo analysis when char_type = "MC", otherwise ignored
#
# mc_trials                  - number of monte carlo trials to use with Variety monte carlo analysis when char_type = "MC, otherwise ignored
#
# aocv_chain_length          - Number of stages for AOCV characterization
#
# aocv_format                - aocv_format = 'synopsys' or 'cadence'
#
# aocv_sigma_factor          - set to value for sigma factor for aocv characterization
# 
# debug_simulation           - set to 0 for standard characterization
#                            - set to 1 to turn on debug messaging 
#                                - Turns off SKI
#                                - Turns on extsim_save_passed to save Spectre decks
#                                - Set constraint debug variables
#                                      
#############################################################################################################################

set libname                            "gpdk"
set recovery                           0

set extsim_cmd                         "/icd/flow/SPECTRE/SPECTRE211/latest/lnx86/bin/spectre"

set netlist_extension                  "sp"
set packet_clients                     10
set arcs_per_thread                    1
set threads                            1
set mem                                10000
set rsh_cmd                            "/grid/sfi/farm/bin/bsub -q tfo-ndpc-bat -P LIBERATE:19.2:GIGA:Eval -n $threads -W \"48:00\" -R \"OSREL>=EE70 || OSREL==EE60 rusage\[mem=$mem\] span\[hosts=1\]\" -o %B/%L -e %B/%L"
#set rsh_cmd                                   "local"

set driver_type                        "predriver"
set driver_cell                        ""

set autoindex                          "noAI"

set simulator                          "SKI"

set ccs                                1
set ccsn                               1
set ccsp                               1

set ecsm                               1
set ecsmn                              1
set ecsmp                              1

set async_pins                         { rb sb r s sn rst rst_b  set set_b }

set ccs_cap                            0
set ccsn_char_type                     2 ; # dont recommend to change
set ccsn_model_type                    0

set lvf_model_moments                  1

set mc_cores                           1
set mc_trials                          3
set trials                             10
set mc_req                             [expr $mc_cores+1]
set rsh_cmd_mc                         "/grid/sfi/farm/bin/bsub -q tfo-ndpc-bat -P LIBERATE:19.2:GIGA:Eval -n $threads -W \"48:00\" -R \"OSREL>=EE70 || OSREL==EE60 rusage\[mem=$mem\] span\[hosts=1\]\" -o %B/%L -e %B/%L"
#set rsh_cmd_mc                               "local"

set debug_simulation                   0

# Em Settings
set em_include_string                  ".dspf_include"
set em_tech_file                       "${model_dir}/models/ictfile"

# AOCV settings
set aocv_chain_length                  15
set aocv_format                        "cadence"
set aocv_sigma_factor                  1


# printing init setup details
puts "INFO (trio-flow): rundir is $rundir"
puts "INFO (trio-flow): Process is $process"
puts "INFO (trio-flow): char_type is $char_type"
puts "INFO (trio-flow): config_dir is     $config_dir"
puts "INFO (trio-flow): scripts_dir is    $scripts_dir"
puts "INFO (trio-flow): process_dir is    $process_dir"
puts "INFO (trio-flow): templates_dir is  $templates_dir"
puts "INFO (trio-flow): model_dir is      $model_dir"
puts "INFO (trio-flow): outdir is         $outdir"
