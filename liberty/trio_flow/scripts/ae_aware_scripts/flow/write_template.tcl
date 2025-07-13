# writing template file

if {$argc < 2} {
   puts "Usage : write_template.tcl <cells-list> <input library> \[auto_index\]"
   exit
}
set cellsfile [lindex $argv 0]
set inLibfile [lindex $argv 1]
set autoIndex [lindex $argv 2]
set dir control_$autoIndex

set cells  [exec cat ${cellsfile}]

set template_if_active 0
set_var adjust_tristate_load 1 ; # need to double check  whether to have 1 or 2

read_library $inLibfile
set_default_group -criteria {delay off power off leakage off cap max}

exec mkdir -p $dir
if {[regexp "auto_index" $dir]} {
   write_template -auto_index -define_max_trans -cells $cells -sdf_cond -mpw -pvt_filename $dir/pvt_common.tcl -verbose -dir $dir $dir/template_common.tcl
} else {
   # if you want to maintain NDWs from library read-in
   #write_template -driver_waveform -define_max_trans -cells $cells -sdf_cond -mpw -pvt_filename $dir/pvt_common.tcl -unique_power -verbose -dir $dir $dir/template_common.tcl
   write_template                   -define_max_trans -cells $cells -sdf_cond -mpw -pvt_filename $dir/pvt_common.tcl -unique_power -verbose -dir $dir $dir/template_common.tcl
}

# NOTE
# Once template is generated, please open template_common.tcl file and remove/comment "set cells ..." and "source ..." lines
# review pvt_common.tcl file and make sure that relevant info (set_vdd/gnd, set_pin_vdd/gnd etc) is ported into your <process>/pvt.tcl file
