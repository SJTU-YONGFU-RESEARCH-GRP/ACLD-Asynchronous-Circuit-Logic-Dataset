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
if {[llength $argv] < 2} {
   puts "Usage: splitLibsInSubsetLibs.tcl <lib_file> <celllist_1> \[cell_list__2\] ... \[cell_list_n\]"
   exit
}

# writing subset lib file
proc writeSubSetLib {lib new_lib subSetLib} {
   foreach cid [$new_lib getChildren cell] {
      $lib copyGroup $cid
   }
   puts "Info (tri-flow): writing subset lib $subSetLib"
   $lib writeDb $subSetLib 0 1
}

### Main ###
set libfile   [lindex $argv 0]
set cellfiles [lrange $argv 1 end]

set lib [read_db $libfile]
set i 0
foreach cf $cellfiles {
   incr i
   set subSetLib "${libfile}_subSet_$i"
   set new_lib [create_db $subSetLib]
   foreach cell [split [exec cat $cf] \n] {
      set cellid [$lib getChildren cell $cell]
      $new_lib copyGroup $cellid
   }
   lappend newLibs $new_lib
}

set i 0
foreach newlib $newLibs {
   incr i
   set subSetLib "${libfile}_subSet_$i"
   set allcellIds [$lib getChildren cell]
   if {[llength $allcellIds] > 0} {$lib delGroup $allcellIds}
   writeSubSetLib $lib $newlib $subSetLib
}
