set library [lindex $argv 0]
set outdir [lindex $argv 1]

compare_ccs_nldm -report ${outdir}/ccs_vs_nldm.txt -abstol 1e-12 -reltol 0.01 -format txt $library
