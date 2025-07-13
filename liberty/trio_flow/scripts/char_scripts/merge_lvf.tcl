
set pvt       [lindex $argv 0]
set nom_lib   [lindex $argv 1]
set lvf_lib   [lindex $argv 2]

source config/init.tcl
set filename ${libname}_${pvt}

read_library $nom_lib

set model_options { \
        -unique_pin_data \
        -capacitance_range 0 \
        -driver_waveform \
        -driver_waveform_size 45 \
        -overwrite \
        -precision "%0.6g" }


if {[file exists ${nom_lib}] && [file exists ${lvf_lib}]} {
    puts "INFO (LVF MERGE-flow): Found NOM file $nom_lib"
    puts "INFO (LVF MERGE-flow): Found LVF file $lvf_lib"

    eval write_library \
        $model_options \
        -sensitivity_file ${lvf_lib} \
        -filename  ${nom_lib}_lvf \
        $filename
}

