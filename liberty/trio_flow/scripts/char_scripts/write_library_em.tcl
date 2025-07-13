
write_library \
    -em \
    -unique_pin_data \
    -cells $cells \
    -overwrite \
    -precision "%0.6g" \
    -filename  $outdir/libs/${filename}_em.lib \
    $filename

