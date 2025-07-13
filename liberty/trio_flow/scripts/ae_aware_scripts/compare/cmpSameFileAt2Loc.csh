#!/bin/csh 

set refdir=$1
set tardir=$2

\rm -rf cmp_tmp.log
foreach c(`ls $tardir`)
   echo "sdiff - $refdir/$c $tardir/$c " |& tee -a cmp_tmp.log
   sdiff -s $refdir/$c $tardir/$c |& tee -a cmp_tmp.log
end
