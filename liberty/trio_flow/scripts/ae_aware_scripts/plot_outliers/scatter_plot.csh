#!/bin/csh

if ($#argv != 3) then
   echo "Usage: $0 <f_vs_g> <g_vs_a> <outdir>"
   exit 0
endif

set f_vs_g=$1
set g_vs_a=$2
set outdir=$3

set plot_title="Aging_Error_Plot"

# delay
 set type=delay
#                                                                                  fresh, golden, diff %diff
grep " $type " $f_vs_g | egrep -v "SUMMARY|\(|outlier|Failed|LIBRARY" | sed -e 's/%//g' | awk -F\| '{print $5, $6, $7, $8}' >! $outdir/f_vs_g_${type}.dat ; # collecting fresh and golden both
#                                                                                  golden, aging, diff %diff
grep " $type " $g_vs_a | egrep -v "SUMMARY|\(|outlier|Failed|LIBRARY" | sed -e 's/%//g' | awk -F\| '{print $5, $6, $7, $8}' >! $outdir/g_vs_a_${type}.dat ; # collecting only aged
paste f_vs_g_${type}.dat g_vs_a_${type}.dat | awk '{print ($2-$1)*100/$1, ($6-$2)*100/$6, ($2-$1), ($6-$2)}' >! $outdir/gff_aga_gf_ag_${type}.dat

# rising|falling slews
set type=trans
egrep " rising | falling " $f_vs_g | egrep -v "SUMMARY|\(|outlier|Failed|LIBRARY" | sed -e 's/%//g' | awk -F\| '{print $5, $6, $7, $8}' >! $outdir/f_vs_g_${type}.dat ; # collecting fresh and golden both
egrep " rising | falling " $g_vs_a | egrep -v "SUMMARY|\(|outlier|Failed|LIBRARY" | sed -e 's/%//g' | awk -F\| '{print $5, $6, $7, $8}' >! $outdir/g_vs_a_${type}.dat ; # collecting only aged
paste f_vs_g_${type}.dat g_vs_a_${type}.dat | awk '{print ($2-$1)*100/$1, ($6-$2)*100/$6, ($2-$1), ($6-$2)}' >! $outdir/gff_aga_gf_ag_${type}.dat

# rise cap|fall cap
set type=cap
egrep "rise cap|fall cap" $f_vs_g | egrep -v "SUMMARY|\(|outlier|Failed|LIBRARY" |sed -e 's/%//g' | awk -F\| '{print $5, $6, $7, $8}' >! $outdir/f_vs_g_${type}.dat ; # collecting fresh and golden both
egrep "rise cap|fall cap" $g_vs_a | egrep -v "SUMMARY|\(|outlier|Failed|LIBRARY" |sed -e 's/%//g' | awk -F\| '{print $5, $6, $7, $8}' >! $outdir/g_vs_a_${type}.dat ; # collecting only aged
paste f_vs_g_${type}.dat g_vs_a_${type}.dat | awk '{print ($2-$1)*100/$1, ($6-$2)*100/$6, ($2-$1), ($6-$2)}' >! $outdir/gff_aga_gf_ag_${type}.dat

exit
foreach type (delay trans)
   set scatter_png=gff_aga_gf_ag_${type}.png

   echo 'set terminal png' >! $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd
   echo 'set output "SCATTER_PNG"' >>! $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd

   echo 'set title "PLOT_TITLE"' >>! $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd

   echo 'set xlabel "Aging(%)"' >>! $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd
   echo 'set ylabel "Error(%)"' >>! $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd

   echo 'set autoscale' >>! $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd

   echo 'plot  "gff_aga_gf_ag_TYPE.dat" using 1:2 title "TYPE_Delta_Error_vs_Aging"' >>! $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd

   perl -p -i -e "s/TYPE/$type/g" $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd
   perl -p -i -e "s/SCATTER_PNG/$scatter_png/g" $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd
   perl -p -i -e "s/PLOT_TITLE/$plot_title/g" $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd
   perl -p -i -e "s/GFF_AGA_GF_AG_TYPE/gff_aga_gf_ag_${type}/g" $outdir/gnuplot_gff_aga_gf_ag_${type}.cmd

   cd $outdir

   /usr/bin/gnuplot gnuplot_gff_aga_gf_ag_${type}.cmd

   echo "scatter plot file - $outdir/$scatter_png"
end

