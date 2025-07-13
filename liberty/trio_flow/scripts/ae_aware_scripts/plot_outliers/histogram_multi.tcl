###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
#!//grid/common/bin/tclsh
if {$argc != 3} {
   puts "Usage: histogram_multi.tcl <datafile1,datafile2> <binStep> <outfile>"
   puts "  <datafile> - should be simple one number per row like :\n1\n2\n3\n10\n20\n\n"
   puts "  <binStep> - 0.001
   puts "  <outfile> - histo/freq data file"
   exit 0
}

# to find base rootname for file; a.b -> a or a.c.d.e -> a
proc findRootName {df} {
   set dft [file tail $df]
   set dfr [file rootname $dft]
   
   set flag 1
   while {$flag == 1} {
      set n_dfr [file rootname $dfr]
      if {$n_dfr == $dfr} {
         set flag 0 ; return $n_dfr
      } else {
         set dfr [file rootname $dfr]
      }
   }
   puts "Error: base root name for file is empty($n_dfr). Please make sure file name does not start with . (DOT)" ; exit 0   
}

# <original_data_file>.txt
set datafiles [split [lindex $argv 0] ","]
foreach df $datafiles {
   puts "info: working on data file $df ..."
   set data [lsort -real -increasing [split [exec cat $df] \n]]
   puts "after - info: working on data file $df ..."
   lappend min [string trim [lindex $data 0]]
   lappend max [string trim [lindex $data end]]
}
set min [lindex [lsort -real -increasing $min] 0]
set max [lindex [lsort -real -increasing $max] end]

set step [lindex $argv 1]
set bins $min
set num $min
while {$num <= $max} {
   set num [format "%0.6f" [expr $num + $step ] ]
   lappend bins $num
}
lappend bins $max

set outfile [lindex $argv 2]

if {[llength $bins] == 0} {
   puts "BINS = $bins"
   puts "data min = $min"
   puts "data max = $max"
   puts "i_max =[lsearch $bins $max] "
   puts "i_min =[lsearch $bins $min] "
   puts "ERROR: bins ($bins) size is NULL for $datafile" ; exit 0
} 

# init each freq/histo bar
set count 0
foreach df $datafiles {
   puts "Info: Initializing bins for $df .."
   set data [lsort -real -increasing [split [exec cat $df] \n]]
   array set freq {}
   foreach b $bins {set freq($b) 0}
   # assuming data is in increasing order
   foreach d $data {
      set flag($d) 1
      foreach b $bins {
         puts "Info: Adding data to histogram $df - $d - $b"
         if {$d <= $b && $flag($d)} {
            incr freq($b) ; set flag($d) 0
         }
      }
   }

   # writing raw data.freq data to a file
   set df_fn [file rootname [file tail $df]] ; lappend df_fns $df_fn
   set wt [open "${df_fn}.histo" w]
#   puts $wt "[file tail $datafile]  #[file tail $datafile]"
   foreach b $bins {
     lappend bf $freq($b)
     puts "Info: writing histogram data to ${df_fn}.histo - $b - $bf"
     puts $wt "$b, $freq($b)"
   }
   close $wt
   incr count
}

#writing gnuplot script to plot data file
set wt [open "[file dir $outfile]/gnu_[file tail $outfile].plot" w]
puts $wt "

reset
set terminal pngcairo size 700,524 enhanced font 'Helvetica,10' linewidth 0.5
set style line 2 lt 1 lc rgb '#A6CEE3' # light blue
set style fill transparent solid 0.5  noborder
set datafile commentschars \"#*\"
set datafile separator \",\"

# axes
set style line 11 lc rgb '#808080' lt 1
set border 3 front ls 11
set tics nomirror out scale 0.75
# grid
set style line 12 lc rgb'#808080' lt 0 lw 1
set grid back ls 12
set grid xtics ytics mxtics

## just setting the axes to something useful. Probably should match how the histogram is generated for.
set xrange \[${min}:${max}\]
set yrange \[0:\]
set arrow from 0, graph 0 to 0, graph 1 nohead

set output '[file dir $outfile]/pic_[file tail $outfile].png'
set title \"Histogram Chart for [file tail $outfile]\"
"
set colorList [list "blue" "purple" "gold" "green" "yellow"]

if {[llength $colorList] < [llength $df_fns]} {
   puts "Error: Please add more color to ColorList. It should be unique and atleast [llength $df_fns] number of colors" ; exit 0
}

set i 0
foreach df $df_fns {
   puts "Info : adding histogram for $df to plot"
   set ttl_df [findRootName $df]
   lappend str "\"${df}.histo\" using 1:2 with filledcurves above y1=0  lc rgb \"[lindex $colorList $i]\" title \"${ttl_df}\","
   incr i
}
set str [join $str " "]
puts $wt "plot $str"
close $wt

#exec gnuplot gnu_[file tail $datafile].plot
#exec display pic_[file tail $datafile].png
