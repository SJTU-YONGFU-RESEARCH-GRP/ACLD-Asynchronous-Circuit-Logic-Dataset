set nom_lib   [lindex $argv 0]
set em_lib    [lindex $argv 1]
set rundir    $env(PWD)

if {[file exists ${nom_lib}] && [file exists ${em_lib}]} {
    puts "INFO (EM MERGE-flow): Found NOM lib file ${nom_lib}"
    puts "INFO (EM MERGE-flow): Found EM lib file ${em_lib}"

    merge_library \
     -type em \
     -method append \
     -driver_waveform \
     -unique_pin_data \
     -filename  ${nom_lib}_em \
     ${nom_lib} ${em_lib}

    puts "INFO (EM MERGE-flow): EM lib file is ${nom_lib}_em"
} 

#exec rm ${rundir}/emirreport.v

