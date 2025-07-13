###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
#################################################################################
## genArcs.tcl : 
##   Main Tcl script which generate define_arc/define_leakage commands
##   based on userArcs info (see IO_userArcsInfo.csv for sample) provided by user
##
## Author : Praveen, Cadence Design Syetem, Inc.             
## Updated on : 04/12/2021
#################################################################################
proc addNewline {} {
   global nl
   global indent
   global defArcs
   incr nl
   if {$nl == 2} {
      set indent "            "
      append defArcs "\\\n"
      set nl 0
   }
}

# prod to generate TMPL_userArcsInfo.tcl from csv file
proc genUserArcsInfo {csvfile outfile} {
   set rd [open $csvfile r]
   set wt [open $outfile w]

   puts $wt "set userArcs {"
   # reading first line as header.
   # CAUTION: dont keep any blank header for which you have values
   gets $rd line
   foreach hline [split $line ","] {
      lappend headerList [string trim $hline]
   }
   set hcellname_idx [lsearch $headerList "CELLNAME"]
   set headerList [lrange $headerList 0 $hcellname_idx] ; # ignoring any col after CELLNAME column
   
   while {[gets $rd line]>= 0} {
      # ignoring any comment line starting with "#"
      if {[regexp {(^[ ]*#.*$)} $line]} {puts "COMMENT: $line" ; continue}
      set strArcs ""
      set ValList [split $line ","]
      for {set cnt 0} {$cnt < [llength $headerList]} {incr cnt} {
         set val [string trim [lindex $ValList $cnt]]
         set key [string trim [lindex $headerList $cnt]]
         if {$val != ""} {
            append strArcs "{$key {$val}} "
         }
      }
      puts $wt "{$strArcs}"
   }
   puts $wt "}"
   close $rd
   close $wt
}

# MAIN SCRIPT
if {$argc != 2} {
   puts ""
   puts "
Usage : genArcs.tcl <embTmpl> <IO_userArcsInfo.csv>
embTmpl=0 : generates define_arc.tcl or define_leakage.tcl file(s) based on 
            userArcs info which can be sourced into template file as under:

            genArcs.tcl 0 IO_userArcsInfo.csv
            source define_arc.tcl ; source define_leakage.tcl

embTmpl=1 : does not generate saperate file but embed related define_arc/define_leakage
            into template.tcl which means this script can directly be called into template file as under:

            genArcs.tcl 1 IO_userArcsInfo.csv"
   puts ""
   exit
}
set embTmpl [lindex $argv 0]
set userArcsInfo [lindex $argv 1]

# generating TMPL_userArcsInfo.tcl from csv file
genUserArcsInfo $userArcsInfo TMPL_userArcsInfo.tcl
set userArcsInfo TMPL_userArcsInfo.tcl

if {$embTmpl == 0} {
   # opening these files for writing arcs info
   set wt1 [open define_arc.tcl w]
   set wt2 [open define_leakage.tcl w]
}

# sourcing userArcsInfo.tcl
source $userArcsInfo
# Iteration if userArcs variable is defined
if {[info exists userArcs]} {
   # iteratinig for each $uArcs in list $userArcs
   foreach uArcs $userArcs {
      # setting/resetting init variables
      set defArcs "" ; set leakArcFlag 0 ; set nl 0
      # iterating over each paired value {key val} under $uArcs
      foreach keyval $uArcs {
         set indent " "
         # key = first element of $keyval
         # val = second to last elements of $keyval
         set key [lindex $keyval 0]
         set val [lrange $keyval 1 end]
         # making define_arc/define_leakage readable
         addNewline
         # type = leakage means leakArcFlag=0 which will egenrate a define_leakage command else define_arc command
         if {$key == "type" && $val == "leakage"} {
            set leakArcFlag 1
         } elseif {$key == "OPTIONS"} {
            # if key is OPTIONS keyword then we just add val to define_arc/leakage command
            set valstr [join $val " "]
            append defArcs "${indent} $valstr "
         } elseif {$key == "CELLNAME"} {
            # if key is CELLNAME keyword then we just add val to define_arc/leakage command
            set cells "${indent}$val"
         } else {
            # adding all paired kay-val to command.. key is option name & val is option value on those command
            append defArcs "${indent}-$key $val "
         }
      }

      # leakArcFlag = 1 means generation of define_leakage command else define_arc command
      if {$leakArcFlag == 1} {
         if {$embTmpl == 0} {
            puts "Info (genArcs) : define_leakage $defArcs $cells"
            # writting to define_leakage.tcl file
            puts $wt2 "define_leakage $defArcs $cells" ; puts $wt2 "\n"
         } else {
            # evaluation of "define_leakage command
            eval "define_leakage $defArcs $cells"
         }
      } else {
         if {$embTmpl == 0} {
            puts "Info (genArcs) : define_arc $defArcs $cells"
            # writting to define_arc.tcl file
            puts $wt1 "define_arc $defArcs $cells" ; puts $wt1 "\n"
         } else {
            # evaluation of define_arc command
            eval "define_arc $defArcs $cells"
         }
      }
   }
}
if {$embTmpl == 0} {
   close $wt1
   close $wt2
}
