#!/bin/csh -f

###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
if ($#argv != 2) then
   echo "Usage: $0 <reflib> <name for cell file>"
   exit 0
endif

set rootdir=`/usr/bin/dirname $0`
set rootdir=`cd $rootdir && pwd`

set reflib=$1
set cellfile=$2

egrep "cell \(|cell\(" $reflib | egrep -v "test_cell" | awk -F\( '{print $2}' | awk -F\) '{print $1}' > /tmp/cells_103$$
grep "cell_footprint" $reflib | awk -F\: '{print $2}' | sed -e 's/"//g'   |sed -e 's/;//g' > /tmp/footprint_103$$
cat /tmp/footprint_103$$ | awk -F\_ '{print $1}' > /tmp/map_103$$

set count=`cat /tmp/footprint_103$$ |wc -l`
grep "area" $reflib | awk -F\: '{print $2}' | sed -e 's/ //g' | sed -e 's/;//g' |tail -n ${count} > /tmp/area_103$$
#/usr/bin/tclsh $rootdir/loop.tcl  $count > /tmp/drive_103$$

#paste /tmp/cells_103$$ /tmp/map_103$$ /tmp/footprint_103$$ /tmp/area_103$$ /tmp/drive_103$$ | awk '{printf "%-40s %-20s %-30s %-8s %-3s \n", $1, $2, $3, $4, $5}' > $cellfile.map_allcells
paste /tmp/cells_103$$ /tmp/map_103$$ /tmp/footprint_103$$ /tmp/area_103$$ | awk '{printf "%-40s %-20s %-30s %-8s \n", $1, $2, $3, $4}' > $cellfile.map_allcells
awk '{print $1}' $cellfile.map_allcells > $cellfile.list_allcells

\rm -rf $cellfile.map_unique
foreach c(`cat $cellfile.map_allcells |awk '{print $2}' |sort -u `)
#   grep -w $c $cellfile.list |head -1 >> $cellfile.map
#      grep -w $c $cellfile.map_allcells |head -1 >> $cellfile.map_unique
#      end
#      awk '{print $1}' $cellfile.map_unique > $cellfile.list_unique
#
#      echo "cell map file - $cellfile.map_allcells"
#      echo "cell map file - $cellfile.list_allcells"
#      echo "cell map file - $cellfile.list_unique"
#      echo "cell map file - $cellfile.map_unique"
