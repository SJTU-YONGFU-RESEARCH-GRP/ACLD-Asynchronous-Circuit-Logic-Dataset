
set rundir $env(PWD)
set pvt         $env(PVT_CORNER)
set process     $env(PROCESS_NAME)
set char_type   $env(CHAR_TYPE)
set outdir      ${rundir}/char_${process}_${pvt}_MC
set model_dir   ${rundir}/${process}/process_models

source config/init.tcl
source cells.tcl
set filename ${libname}_${pvt}

set lvf_lib   ${rundir}/char_${process}_${pvt}_LVF/libs/${filename}_lvf.lib
set mc_lib    ${rundir}/char_${process}_${pvt}_MC/libs/${filename}_mc.lib

puts "LVF MERGE FLOW INFO: rundir is $rundir"
puts "LVF MERGE FLOW INFO: PVT is $pvt"
puts "LVF MERGE FLOW INFO: Process is $process"
puts "LVF MERGE FLOW INFO: char_type is $char_type"

puts "LVF MERGE FLOW INFO: model_dir is      $model_dir"
puts "LVF MERGE FLOW INFO: outdir is         $outdir"
puts "LVF MERGE FLOW INFO: filename is       $filename"

puts "LVF MERGE FLOW INFO: LVF lib file is $lvf_lib"
puts "LVF MERGE FLOW INFO: MC lib file is $mc_lib"


if {[file exists $lvf_lib]} {
    if {![file exists $outdir/libs/variation_validation]} {
        puts "LVF MERGE FLOW INFO: Creating directory $outdir/libs/variation_validation"
        exec mkdir $outdir/libs/variation_validation
    }

        compare_library \
            -abstol {ocv_delay 2e-12 ocv_trans 2e-12 ocv_const 2e-12} \
            -reltol {ocv_delay 0.02  ocv_trans 0.02  ocv_const 0.05} \
            -type {ocv_delay ocv_trans ocv_const} \
            -exact_match \
            -report $outdir/libs/variation_validation/compare_lvf2mc.txt \
            -gui    $outdir/libs/variation_validation/compare_lvf2mc.gui \
            -verbose \
            $mc_lib $lvf_lib
}

#    -ocv_include_nominal \
