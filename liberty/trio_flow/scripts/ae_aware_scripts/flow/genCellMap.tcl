###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################

#########################################################
# Usage: liberate genCellMap.tcl <input_lib> 
##########################################################

set input_lib [lindex $argv 0]
set inputLib [read_db $input_lib]
set cellListAll "cells.list_all"
set cellListUnique "cells.list_unique"
set cellMapListAll "cells.map_all"
set cellMapListUnique "cells.map_unique"
set cla [open "$cellListAll" w+]
set clu [open "$cellListUnique" w+]
set cmla [open "$cellMapListAll" w+]
set cmlu [open "$cellMapListUnique" w+]
# interate thru each cell
set flag "dummy"
foreach cell [$inputLib getChildren cell] {
    set cellFootPrint ""
    set cellName [$cell getName]
    foreach {k1 v1} [$cell getAttr cell_footprint] {set cellFootPrint $v1}
    if {$cellFootPrint eq ""} {set cellFootPrint $cellName}
    foreach {k2 v2} [$cell getAttr area] {set area $v2}
    puts $cla "$cellName"
    puts $cmla "$cellName\t$cellFootPrint\t$cellFootPrint\t$area"
    if {$cellFootPrint ne $flag} {
        puts $clu "$cellName"
        puts $cmlu "$cellName\t$cellFootPrint\t$cellFootPrint\t$area"
        set flag $cellFootPrint
    }
}
close $cla 
close $clu 
close $cmla 
close $cmlu 
