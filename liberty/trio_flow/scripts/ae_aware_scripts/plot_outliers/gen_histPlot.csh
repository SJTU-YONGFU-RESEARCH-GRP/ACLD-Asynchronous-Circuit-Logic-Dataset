/bin/csh -f

if ($#argv != 3) then
   echo "Usage: $0 <datafile1,datafile2,..> <step> <outfile>"
   exit 0
endif
set datafiles=$1
set step=$2
set outfile=$3

set scriptdir=`/usr/bin/dirname $0`
set scriptdir=`cd $scriptdir && pwd`

foreach df (`echo $datafiles |sed -e 's/,/ /g'`)
   awk -F\, '{print $1}' $df |awk '{print $1}' |grep . > $df.txt
end

set datafiles=`echo $datafiles |sed -e 's/,/.txt,/g' |sed -e 's/$/.txt/g'`
echo "datafiles=$datafiles"

#Usage: histogram.tcl <datafile1,datafile2> <binStep> <outfile>
$scriptdir/histogram_multi.tcl $datafiles $step $outfile

# plot and display
# exec /grid/common/bin/gnuplot gnu_${outfile}.plot
# exec display pic_${outfile}.png
# ~                                
