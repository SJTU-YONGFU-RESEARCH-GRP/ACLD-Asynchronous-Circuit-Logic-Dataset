
#define_pvt -default tt_1p1v_25c {
	set pvt_name     tt_1p1v_25c 
   	set temp         25
   	set corner       tt
   	set vdd          1.1
   	set vss          0.0
   	set netlist_sub_dir   ""
   	set template_sub_dir  ""
   	set max_transition 4.2e-10
    set min_transition 1.2e-11
    set min_output_cap 1e-17
#}

# define_pvt ss_1p0v_125c {
#	set pvt_name     ss_1p0v_125c
#   	set temp         125
#   	set corner       ss
#   	set vdd          1.0
#   	set vss          0.0
#   	set netlist_sub_dir   ""
#   	set template_sub_dir  ""
#   	set max_transition 3.2e-10
#   	set min_transition 1.5e-11
#    set min_output_cap 1e-17
#}
    

# modify these set_vdd/gnd as per your need and as per ref lib if you have one. 
# also add set_vdd/gnd and set_pin_vdd/gnd from pvt_common.tcl file which is generated when you genearte template using char_scripts/write_template.tcl
set_vdd -type primary       -attributes { direction input }  ExtVDD    $vdd
set_gnd -type primary       -attributes { direction input }  ExtVSS    $vss
set_vdd -type primary       -attributes { direction input }  VDD    $vdd
set_gnd -type primary       -attributes { direction input }  VSS    $vss

set_operating_condition  -name  $pvt_name  -voltage  $vdd  -temp  $temp

