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

if ($#argv < 2) then
   echo "Usage: $0 <lib1> <lib2> [..] [libn]"
   echo "       <lib1> = lib1.lib"
   exit
endif

set tmpdir=`pwd`/tmpdir
mkdir -p $tmpdir

foreach lib ($argv )
   liberate --trio splitLibsInPerCellLib.tcl $tmpdir $lib
end

liberate --trio append_libs.tcl $tmpdir append_lib

# clean up tmpdir
# rm -rf $tmpdir

