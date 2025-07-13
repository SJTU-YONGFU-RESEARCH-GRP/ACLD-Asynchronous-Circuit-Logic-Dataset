
set ref_lib <ref_lib>
set cmp_lib <cmp_lib>

puts "Ref lib is $ref_lib"
puts "Cmp lib is $cmp_lib"

# source cells.tcl

compare_library \
    -report compare_library.txt \
	-gui    compare_library.gui \
	-abstol {ccsp_dc 4000 cap 2e-15 delay 2e-12 trans 2e-12 power 4e-15 leakage 4e-09 constraint 2e-12 ocv_delay 2e-12 ocv_trans 4e-12 ocv_const 4e-12 } \
    -reltol {ccsp_dc 0.02 cap 0.02  delay 0.02  trans 0.02  power 0.02  leakage 0.02  constraint 0.02  ocv_delay 0.02  ocv_trans 0.04  ocv_const 0.04 } \
    -verbose \
    $ref_lib $cmp_lib

	#-cells $cells \
