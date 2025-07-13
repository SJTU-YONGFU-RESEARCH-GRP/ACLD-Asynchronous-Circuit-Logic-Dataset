#!/bin/csh 

###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
if ($#argv != 3) then
   echo "Usage: $0 <delay_dat> <trans_dat> <aging|nom>"
   exit 0
endif

set delay_dat=$1
set trans_dat=$2
set type=$3 ; # aging|nom

set script_dir=$ALOTSHOME/examples/trio_flow/scripts/char_scripts/ae_aware_scripts
echo "copying to tmp area..."
\cp -rp $script_dir/gnu_histogram.cmd .gnu_histogram.cmd_$$
   
set minimum=`cat $delay_dat $trans_dat | awk '{print $4}' |sort -nu |head -1`
set maximum=`cat $delay_dat $trans_dat | awk '{print $4}' |sort -nu |tail -1`

perl -p -i -e "s/TYPE/$type/g" .gnu_histogram.cmd_$$
perl -p -i -e "s/MINIMUM/$minimum/g" .gnu_histogram.cmd_$$
perl -p -i -e "s/MINIMUM/$minimum/g" .gnu_histogram.cmd_$$
perl -p -i -e "s/MAXIMUM/$maximum/g" .gnu_histogram.cmd_$$
perl -p -i -e "s/G_VS_A_DELAY_DAT/$delay_dat/g" .gnu_histogram.cmd_$$
perl -p -i -e "s/G_VS_A_TRANS_DAT/$trans_dat/g" .gnu_histogram.cmd_$$

/usr/bin/gnuplot .gnu_histogram.cmd_$$
