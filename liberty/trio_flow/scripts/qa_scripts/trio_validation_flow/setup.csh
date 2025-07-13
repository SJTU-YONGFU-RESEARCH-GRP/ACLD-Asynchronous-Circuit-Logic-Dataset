#!/bin/csh -f

setenv CDS_AUTO_64BIT all

## For Liberate and Liberate LV
## Set Liberate Installation path
setenv ALTOSHOME <Liberate installation path> 
setenv PATH $ALTOSHOME/bin:$PATH

## Need to point to Tempus installation path for running Library Scaling
setenv ALTOSHOME <Tempus installation path>
setenv PATH $ALTOSHOME/bin:$PATH


