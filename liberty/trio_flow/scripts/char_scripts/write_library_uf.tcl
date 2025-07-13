
set model_options { \
        -unique_pin_data \
        -capacitance_range 0 \
        -driver_waveform \
        -driver_waveform_size 45 \
        -user_data $process/user_data/user_data.lib \
        -overwrite \
        -precision "%0.6g" }


# NOTE: If modeling ccsp, must model ccsp first if there are multiple write_library commands
eval write_library \
    -ccs \
    -ccsp \
    -ccsn \
    -lvf \
    -cells [list $cells] \
    $model_options \
    -filename  $outdir/libs/${filename}_ccstnp_lvf.lib \
    $filename
