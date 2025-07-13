
write_variation \
    -conf_interval \
    -unique_pin_data \
    -capacitance_range 0 \
    -format sensitivity_plus_nom              \
    -user_data $user_data \
    -cells $cells \
    -overwrite \
    -precision "%0.6g" \
    -filename $outdir/libs/${filename}_fmc.lib \
    $filename

