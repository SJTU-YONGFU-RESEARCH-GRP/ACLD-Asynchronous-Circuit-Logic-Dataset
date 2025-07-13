set ref  [lindex $argv 0]
set comp [lindex $argv 1]
set tag  [lindex $argv 2]
set rootdir [pwd]
set rundir $rootdir/out_compare_$tag

define_pvt -default dummy_pvt { }

######################
# BOLT SETUP
######################
set_var bolt_post_char_command_distribution 1
set_var packet_arc_job_manager bolt
set_var packet_client_health_checks 1
set_var packet_clients 5
#set_var rsh_cmd "bsub -q liberate -n 1 -J CLIENT:ARM:INT_RUN2:SPVT -P MPVT:17.1.4:AE:Eval -W \"200:00\" -R \"rusage\[mem=20000\] select\[OSNAME==Linux\] span\[hosts=1\]\" -o %B/%L -e %B/%L"
set_var rsh_cmd local

######################
# CELLS 
######################
set cells [split [exec cat cells.list] \n]
set packet_cells [packet_slave_cells]
if {[llength $packet_cells]>0} { set cells $packet_cells }

set env(ENABLE_PARALLEL_COMPARE_STRUCTURE) true
set_var compare_library_mode 1

char_library -thread 1 -extsim spectre -cells $cells -ecsmn -ccs -ccsn -ccsp
compare_library -abstol 2e-12 -reltol 0.03 -verbose -cells $cells -report $rundir/cmp.txt $ref $comp
compare_structure -verbose -cells $cells -report $rundir/str.txt $ref $comp

