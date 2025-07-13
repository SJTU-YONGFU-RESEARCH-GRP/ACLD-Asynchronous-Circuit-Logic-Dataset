###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
# multiple subset libs are created based on cell list file passed 
if {[llength $argv] != 2} {
   puts "Usage: splitLibsInPerCellLib.tcl <tmpdir> <lib_file>"
   exit
}

proc writeLibs {lib cellid subSetLib} {
   $lib copyGroup $cellid
   $lib writeDb $subSetLib 0 1
   set allcellids [$lib getChildren cell]
   $lib delGroup $allcellids
}
proc splitLib {lib tmpdir} {
   set subSetLib "tmp"
   set new_lib [create_db $subSetLib]
   set allcellids [$lib getChildren cell]
   foreach cellid $allcellids {
      $new_lib copyGroup $cellid
   }
   $lib delGroup $allcellids 
   foreach cellid [$new_lib getChildren cell] {
      set cellName [$cellid getName]
      set subSetLib "$tmpdir/${cellName}.lib"

      writeLibs $lib $cellid $subSetLib
   }
}

### Main ###
set tmpdir [lindex $argv 0]
set libfile [lindex $argv 1]
set lib [read_db $libfile]
splitLib $lib $tmpdir
del_db $lib
