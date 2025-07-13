
write_variation_table \
    -chain_length $aocv_chain_length \
    -filename $outdir/libs/${filename}.aocv \
    -format ${aocv_format} \
    -load_index 0 \
    -slew_index 0 \
    $filename

