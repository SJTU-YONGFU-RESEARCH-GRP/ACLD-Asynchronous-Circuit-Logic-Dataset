#!/bin/csh -f

if ($#argv != 1 ) then 
    echo "Incorrect command line use . . ."
    echo "Usage: library_scaling_summary.csh <reports dir>" 
    exit
endif

echo "Reports dir is $1 \n"

setenv DIR $1

echo "----------------- Library Scaling Summary -----------------" 
echo "Report log : `realpath ${DIR}/tempus/*tps.log `"
set scaling_summary = `grep 'Message Summary' ${DIR}/tempus/*tps.log | cut -d ":" -f2`
echo $scaling_summary
echo "----------------- End Library Scaling Summary ----------------- \n" 



