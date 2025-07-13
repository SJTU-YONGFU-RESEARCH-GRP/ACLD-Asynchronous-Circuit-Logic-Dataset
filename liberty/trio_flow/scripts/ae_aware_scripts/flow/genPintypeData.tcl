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
# Usage: liberate readLib.tcl <input_lib> 
##########################################################
#   set voltage 0.675
#   set vdd  $voltage ; set vddg    $voltage ; set vdde  $voltage
#   set vnw  $voltage ; set biasnw  $voltage ; set vddo  $voltage
#   set vddi $voltage ; set vdd_sub $voltage ; set vddfx $voltage 
#   set vss    0.0 ; set vssg 0.0 ; set vpw   0.0
#   set biaspw 0.0 ; set vsso 0.0 ; set vssfx 0.0
set input_lib [lindex $argv 0]
set familyNameIdx [lindex $argv 1] ; # 3 in this case - x_y_x_invx1
set lib [read_db $input_lib]
set libName [$lib getName]
#set pp [open "${libName}_post_processing.tcl" w+]
#set cmd [open "${libName}_cmd.tcl" w+]
set pp  [open "post_processing.tcl" w+]
set cmd [open "custom_char_setting.tcl" w+]
set familyName ""
# interate thru each input_voltage group
foreach inpVolGrp [$lib getChildren input_voltage] {
    set vil "0"
    set vimin "0"
    set name [$inpVolGrp getName]
    if {([regexp "alwaysonpower" $name]) || ($name eq "alwayson") || ($name eq "header")} {
        set vih "\$vddg"
        set vimax "\$vddg"
    } elseif { $name eq "vddin"} {
        set vih "\$vddi"
        set vimax "\$vddi"
    } elseif { ([regexp vddvssout $name]) || ($name  eq "vddout") } {
        set vih "\$vddo"
        set vimax "\$vddo"
    } else {
        set vih "\$vddfx"
        set vimax "\$vddfx"
    }
    puts $pp "set_attribute \""
    puts $pp "input_voltage($name) {"
    puts $pp "    vil : \[expr 0.3 * $vil\];" 
    puts $pp "    vih : \[expr 0.7 * $vih\];"
    puts $pp "    vimin : -0.5;"
    puts $pp "    vimax : \[expr 0.5 + $vimax\];"
    puts $pp "}"
    puts $pp "\""
}
#iterate through each output_voltage group
foreach outVolGrp [$lib getChildren output_voltage] {
    set vol "0"
    set vomin "0"
    set name [$outVolGrp getName]
    if {([regexp "alwaysonpower" $name]) || ($name eq "alwayson") || ($name eq "header")} {
        set voh "\$vddg"
        set vomax "\$vddg"
    } elseif { $name eq "vddin"} {
        set voh "\$vddi"
        set vomax "\$vddi"
    } elseif { ([regexp vddvssout $name]) || ($name  eq "vddout") } {
        set voh "\$vddo"
        set vomax "\$vddo"
    } else {
        set voh "\$vddfx"
        set vomax "\$vddfx"
    }
    puts $pp "set_attribute \""
    puts $pp "output_voltage($name) {"
    puts $pp "    vol : \[expr 0.1 * $vol\];" 
    puts $pp "    voh : \[expr 0.9 * $voh\];"
    puts $pp "    vomin : -0.5;"
    puts $pp "    vomax :\[expr 0.5 + $vomax\];"
    puts $pp "}"
    puts $pp "\""
}
#iterate through each cell 
foreach cell [$lib getChildren cell] {
    set cellName [$cell getName]
    set newFamilyName [lindex [split $cellName "_"] $familyNameIdx]
    if {$newFamilyName ne $familyName} {
        set familyName $newFamilyName
        foreach bundle [$cell getChildren bundle] {
            if {$bundle ne ""} {
                set pinListHandle [$bundle getChildren pin]
                foreach pin $pinListHandle {
                    set pinName [$pin getName]
                    foreach {k1 v1}  [$pin getAttr direction] {set dir $v1}
                    foreach {k2 v2} [$pin getAttr related_power_pin] { set relPwrPin $v2}
                    foreach {k3 v3} [$pin getAttr related_ground_pin] { set relGndPin $v3}
                    foreach {k4 v4} [$pin getAttr input_signal_level] { set inpSigLvl $v4}
                    if {[info exists relPwrPin]} {
                        set x [string tolower $relPwrPin] 
                        set VDDName $relPwrPin
                    } elseif {[info exists inpSigLvl]} {
                        set x [string tolower $inpSigLvl] 
                        set VDDName $inpSigLvl
                    } else {
                        puts "Error:\t Neither related_power_pin or input_signal_level found for Pin:$piniName Cell:$cellName"
                    }
                    set y [string tolower $relGndPin] 
                    if {$dir eq "input"} {
                        foreach {k1 v1} [$pin getAttr input_voltage] { set inpVolt $v1}
                        puts $pp "set_attribute         -cells *_${newFamilyName}* -pins $pinName input_voltage $inpVolt"
                        if {$inpVolt ne "default"} {
                            puts $cmd "set_pin_vdd -supply_name $VDDName  *_${newFamilyName}*  $pinName  \$$x"
                            puts $cmd "set_pin_gnd -supply_name $relGndPin  *_${newFamilyName}*  $pinName  \$$y"
                        }
                        if {$inpVolt eq "clockpin"} {puts $cmd "define_max_transition  \$clock_max_transition  \{*_${newFamilyName}*  $pinName\}"}  
                        if {$inpVolt eq "vddin"} {
                            puts $cmd "define_max_transition \$max_transition2 \{*_${newFamilyName}*  $pinName\}"
                            puts $cmd "define_min_transition \$min_transition2 \{*_${newFamilyName}*  $pinName\}"
                        }  
                        if {$inpVolt eq "vddout"} {
                            puts $cmd "define_max_transition \$max_transition2 \{*_${newFamilyName}*  $pinName\}"
                            puts $cmd "define_min_transition \$min_transition2 \{*_${newFamilyName}*  $pinName\}"
                        }  
                    } elseif {$dir eq "output"} {
                        foreach {k1 v1} [$pin getAttr output_voltage] { set outVolt $v1}
                        puts $pp "set_attribute         -cells *_${newFamilyName}* -pins $pinName output_voltage $outVolt"
                        if {$outVolt ne "default"} {
                            puts $cmd "set_pin_vdd -supply_name $VDDName  *_${newFamilyName}*  $pinName  \$$x"
                            puts $cmd "set_pin_gnd -supply_name $relGndPin  *_${newFamilyName}*  $pinName  \$$y"
                        }
                        if {$outVolt eq "clockoutputpin"} {puts $cmd "#set_constraint_criteria -cells *_${newFamilyName}* -pins $pinName -glitch_peak 0.1"}
                        if {$inpVolt eq "vddin"} {
                            puts $cmd "define_max_transition \$max_transition2 \{*_${newFamilyName}*  $pinName\}"
                            puts $cmd "define_min_transition \$min_transition2 \{${newFamilyName}*  $pinName\}"
                        }  
                        if {$inpVolt eq "vddout"} {
                            puts $cmd "define_max_transition \$max_transition2 \{*_${newFamilyName}*  $pinName\}"
                            puts $cmd "define_min_transition \$min_transition2 \{*_${newFamilyName}*  $pinName\}"
                        }  
                    }
                }
            }
        } 
        set pinListHandle [$cell getChildren pin]
        foreach pin $pinListHandle {
            set pinName [$pin getName]
            foreach {k1 v1}  [$pin getAttr direction] {set dir $v1}
            foreach {k2 v2} [$pin getAttr related_power_pin] {set relPwrPin $v2}
            foreach {k3 v3} [$pin getAttr related_ground_pin] { set relGndPin $v3}
            foreach {k4 v4} [$pin getAttr input_signal_level] { set inpSigLvl $v4}
            if {[info exists relPwrPin]} {
                set x [string tolower $relPwrPin] 
                set VDDName $relPwrPin
            } elseif {[info exists inpSigLvl]} {
                set x [string tolower $inpSigLvl] 
                set VDDName $inpSigLvl
            } else {
                puts "Error:\t Neither related_power_pin or input_signal_level found for Pin:$piniName Cell:$cellName"
            }
            set y [string tolower $relGndPin] 
            if {$dir eq "input"} {
                foreach {k1 v1} [$pin getAttr input_voltage] { set inpVolt $v1}
                puts $pp "set_attribute         -cells *_${newFamilyName}* -pins $pinName input_voltage $inpVolt"
                if {$inpVolt ne "default"} {
                    puts $cmd "set_pin_vdd -supply_name $VDDName  *_${newFamilyName}*  $pinName  \$$x"
                    puts $cmd "set_pin_gnd -supply_name $relGndPin  *_${newFamilyName}*  $pinName  \$$y"
                }
                if {$inpVolt eq "clockpin"} {puts $cmd "define_max_transition  \$clock_max_transition  \{*_${newFamilyName}*  $pinName\}"}  
                if {$inpVolt eq "vddin"} {
                    puts $cmd "define_max_transition \$max_transition2 \{*_${newFamilyName}*  $pinName\}"
                    puts $cmd "define_min_transition \$min_transition2 \{*_${newFamilyName}*  $pinName\}"
                }  
                if {$inpVolt eq "vddout"} {
                    puts $cmd "define_max_transition \$max_transition2 \{*_${newFamilyName}*  $pinName\}"
                    puts $cmd "define_min_transition \$min_transition2 \{*_${newFamilyName}*  $pinName\}"
                }  
            } elseif {$dir eq "output"} {
                foreach {k1 v1} [$pin getAttr output_voltage] { set outVolt $v1}
                puts $pp "set_attribute         -cells *_${newFamilyName}* -pins $pinName output_voltage $outVolt"
                if {$outVolt ne "default"} {
                    puts $cmd "set_pin_vdd -supply_name $VDDName  *_${newFamilyName}*  $pinName  \$$x"
                    puts $cmd "set_pin_gnd -supply_name $relGndPin  *_${newFamilyName}*  $pinName  \$$y"
                }
                if {$outVolt eq "clockoutputpin"} {puts $cmd "#set_constraint_criteria -cells *_${newFamilyName}* -pins $pinName -glitch_peak 0.1"}
                if {$inpVolt eq "vddin"} {
                    puts $cmd "define_max_transition \$max_transition2 \{*_${newFamilyName}*  $pinName\}"
                    puts $cmd "define_min_transition \$min_transition2 \{*_${newFamilyName}*  $pinName\}"
                }  
                if {$inpVolt eq "vddout"} {
                    puts $cmd "define_max_transition \$max_transition2 \{*_${newFamilyName}*  $pinName\}"
                    puts $cmd "define_min_transition \$min_transition2 \{*_${newFamilyName}*  $pinName\}"
                }  
            }
        }
    }
}
puts $pp "   if \{\[packet_slave_cells\] == \"\" \} \{"
puts $pp "       set files \[glob -dir \$ldb\/\$pvt\/LIBS *.lib*\]"
puts $pp "       foreach file \$files \{"
puts $pp "          if \{\[file exists \$file\]\} \{exec sed -i \"s\/ : ;\/\/g\" \$file\}"
puts $pp "       \}"
puts $pp "   \}"

