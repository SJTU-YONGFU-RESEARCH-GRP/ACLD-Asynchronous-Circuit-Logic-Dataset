
###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
# generate set_pin_vdd, set_pin_gnd input_map and user_data for MBFF cells

set libfile [lindex $argv 0]

set lib [read_db $libfile]
#$lib writeDb 1mod_$libfile 0 1

# iterating over cells, pins to convert 3D const tables to 2D const tables
foreach lchild [$lib getChildren cell] {
   foreach cchild [$lchild getChildren pin] {
      foreach rchild [$cchild getChildren "receiver_capacitance" "*"] {
         set when   [lindex [$rchild getAttr when] 1]
         set isprop [lindex [$rchild getAttr is_propagating] 1]
         if {[llength $when] > 0 && [llength $isprop] == 0} {
            puts "Adding is_propagating=false for receiver_capacitance table for cell [$lchild getName] under pin [$cchild getName] with attributes [$rchild getAttr] ..."
            $rchild setAttr {is_propagating false}
         }
      }
   }
}
$lib writeDb mod_$libfile 0 1
