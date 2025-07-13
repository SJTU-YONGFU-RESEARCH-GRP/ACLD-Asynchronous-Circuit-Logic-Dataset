###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################

###########################
#    Flow scripts         #
###########################

# genCellmap.csh
   -Generate cell map and list based on reference library. It will generate cells.map_allcells, cells.map_unique, cells.list_allcell
   and cells.list_unique
   - Usage: ./genCellmap.csh <reflib> <name for cell file>

# write_template.tcl
   - Strip out template from input libary. 
   - Usage: liberate write_template.tcl <cell-list> <input library> [auto_index]

# genFamilyTmpl.tcl 
   - Generate template file for family cells.
   - Usage: liberate genFamilyTmpl.tcl <cellMapfile> <reflib> <outdir>

# genFamilyUserData.tcl
   - Generate userdata for family cells
   - Usage: liberate genFamilyUserData.tcl <cellMapfile> <reflib> <outdir>

# genCellUserData.tcl
   - Generate userdata for whole library based on family cells userdata 
   - Usage: liberate genCellUserData.tcl  <cellMapfile> <family_userdata_dir> <outdir>

# genCellTmpl.tcl 
   - Generate template files for whole library based on family cells template
   - Usage: liberategenCellTmpl.tcl <cellMapfile> <family_template_dir>  <outdir>

# getUserData_for_MBFF.tcl
   - Generate set_pin_vdd|gnd for each pin
   - Generate userdata for MBFF. Write skelton lib file wiht all attributes/groups you want to inlcude. Please double check the list for include_attrs/groups in the script. 
   - Usage: liberate getUserData_for_MBFF.tcl <reflib> <spvg|userdata|both>

###########################
#   post process scripts  #
###########################

# genCcspOnlyLib.tcl
   - Strip out ccsp data from a ccsp library. This list is based on char_library -ccsp ; no other switches like -ccs, -ccsn, -ecsmp, -ecsmn, -lvf. if you had used other switches then please update group name accordingly to delete
   - Usage: liberate genCcsponlyLib.tcl <reflib> 

# gen_scm_lvf.tcl
   - Generate NOM+LVF or SADHM
   - liberate liberate gen_scm_lvf.tcl <ocvpath> <type> <scm_lvf>

# add_isProp.tcl
   - LDBX example of adding custom attributes to a group. This example is for adding is_propagating 
   - Usage: liberate add_isProp.tcl <lib> 

# fix_non_unate.tcl, fix_non_unate.py 
   - example of tcl+python example for fixing/deleting attribute

###########################
#    split/append libs    #
###########################

# append_libs.tcl
   - Example of append library using append_library 
   - Usage: liberate append_libs.tcl <libdir> <libname>

# splitLibsInPerCellLib.tcl
   - Split library into individual cell level library
   - Usage: liberate splitLibsPerCellLib.tcl <tmpdir> <lib_file>

# appendLibsOverwrite.csh
   - Split library per cell for given libraries.Then merge cell based library into a single library. It used splitLibsInPerCellLib/tcl and append_libs.tcl
   - Usage: appendLibsOverwrite.csh <lib1> <lib2> [...] [libn]

# splitLibsInSubsetLibs.tcl
   - Split library into a subset cells library
   - Usage: liberate splitLibsInSubsetLibs.tcl <lib_file> <celllist_1> [cell_list_2]... [cell_list_n]

# split_cells.py
   - Split library into individual cell level library using python+LDBX
   - Usage: liberate --python split_cells.py <lib_file>

###########################
#        Compare          #
###########################

# cmpSameFileAt2Loc.csh
   - Compare same files under two different directory location.
   - Usage: ./cmpSameFileAt2Loc.csh <refdir> <tardir>

# custom_comp.tcl
   - Example of running compare library using custom equation and tolerance.
   - Usage: liberate custom_comp.tcl <ref_lib> <comp_lib>

# compare_parallel.tcl
   - Example of running compare library in parallel. Please change bsub and bolt settings accrodingly.
   - Usage: liberate --trio compare_parallel.tcl <ref_lib> <comp_lib> <tag> 

###########################
#     plot outliers       #
###########################

#  gnu_histogram.csh, gnu_histogram.cmd
   - Example of plot histogram using gnuplot 
   - Usage: gnu_histogram.csh <delay_dat> <trans_dat> <aging|nom>

#  scatter_plot.csh
   - Example of plot scatter using gnuplot
   - Usage: scatter_plot.csh <file1> <file2> <outdir>

# gen_histPlot.csh, histogram_multi.tcl
   - Example of plot histogram using gnuplot
   - Usage: histogram_multi.tcl <datafile1,datafile2> <binStep> <outfile>

###########################
#         debug           #
###########################

# get_rise_fall_power.py get_rise_fall_power.tcl
    - Example of summing rise and fall power and writing in lib
    - Usage:liberate --trio get_rise_fall_power.tcl <input_lib> <output_lib>

# splitCompressLog.pl
    - Script to split compressed forked simulation/assembly job logfiles
    - Usage: ./splitCompressLog.pl <logfile>

# spectre_wrap
    - Example of spectre wrapper file. Only for non-SKI deck. It doesn't work for SKI.
    - Usage: ./spectre_wrap <sim.sp> 

###########################
#         other           #
###########################

# splitNetlist.pl
    - Split all cells netlist single file to individual cell level netlist file.
    - Usage: ./splitNetlist.pl <netlist>

# gtc.tcl
    - Script to create a testcase out of char setup/work dir
