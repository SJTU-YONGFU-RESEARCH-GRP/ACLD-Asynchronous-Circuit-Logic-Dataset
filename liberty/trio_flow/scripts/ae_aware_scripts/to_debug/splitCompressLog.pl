#! /cadappl/bin/perl

###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################
open(IFILE,"<$ARGV[0]") or die "Not able to open the file $ARGV[0]";
while(<IFILE>) {
                if($_=~m/FILENAME: /){
                @array=split;
                $filename=$array[1];
                open(NEWFILE,">./$filename") or die "Not able to open the file ./spectre/$array[1] \n";
                printf NEWFILE "$_";
                }
                elsif($_=~m/Wall time /){
                        printf NEWFILE "$_";
                        close(NEWFILE);
                }
                else{
                printf NEWFILE "$_";
                }
            }
close(IFILE);

