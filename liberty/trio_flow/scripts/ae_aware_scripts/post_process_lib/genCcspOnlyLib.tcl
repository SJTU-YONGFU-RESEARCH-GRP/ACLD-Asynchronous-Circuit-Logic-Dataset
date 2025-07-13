###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
################# MAIN #############
set libfile  [lindex $argv 0]

set lib [read_db $libfile]
#$lib writeDb ${libfile}_tmp 0 1

# This list is based on char_library -ccsp ; no other switches like -ccs, -ccsn, -ecsmp, -ecsmn, -lvf. 
# if you had used other switches then please update group name accordingly to delete
#set delete_groups {timing internal_power leakage_power input_ccb output_ccb ccsn_first_stage ccsn_last_stage}
set delete_groups {timing internal_power leakage_power}
set_var ldbx_preserve_quotes_int 1

proc deleteGroup {delete_groups keep_groups parent child lvl} {
   set chead [$child getHeader]
   set str ""
   if {[lsearch $delete_groups $chead] != -1} {
      $parent delGroup $child
      if {$lvl == 0} {set str "library"}
      if {$lvl == 1} {set str "cell [$parent getName]"}
      if {$lvl == 2} {set str "cell [[$parent getParent] getName] pin [$parent getName]"}
      if {$lvl == 3} {set str "cell [[[$parent getParent] getParent] getName] bundle [[$parent getParent] getName] pin [$parent getName]"}
      puts "Info (trio-flow): Deleting group $chead from $str ..."
   }
}
# lib children
foreach clib [$lib getChildren] {
   deleteGroup $delete_groups $keep_groups $lib $clib 0
   if {[$clib getHeader] == "cell"} {
      # cell children
      foreach ccell [$clib getChildren] {
         deleteGroup $delete_groups $keep_groups $clib $ccell 1
         if {[$ccell getHeader] == "pin"} {
            # pin children
            foreach cpin [$ccell getChildren] {
               deleteGroup $delete_groups $keep_groups $ccell $cpin 2
            }
         }
         if {[$ccell getHeader] == "bundle"} {
            # bundle children
            foreach cbndl [$ccell getChildren] {
               deleteGroup $delete_groups $keep_groups $ccell $cbndl 3
            }
         }
      }
   }
}
$lib writeDb ${libfile}_ccsp_only 0 1
