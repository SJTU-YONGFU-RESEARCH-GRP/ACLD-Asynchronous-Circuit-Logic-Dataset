#!/bin/csh

set libfile=$1

echo "ldbx_python split_cells.py $libfile" > /tmp/mysplt$$.tcl
liberate --trio /tmp/mysplt$$.tcl

