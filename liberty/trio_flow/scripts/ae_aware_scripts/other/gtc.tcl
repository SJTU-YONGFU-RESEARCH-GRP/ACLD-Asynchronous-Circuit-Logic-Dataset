#|-----------------------------------------------------------------------|
#|                                                                       |
#|      _               Copyright (c) 2015-2018,                         |
#|    c a d e n c e     Cadence Design Systems, Inc.                     |
#|                      All Rights Reserved                              |
#|                                                                       |
#|                                                                       |
#| THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF CADENCE DESIGN SYSTEMS |
#| The copyright notice above does not evidence any actual or intended   |
#| publication of such source code.                                      |
#|                                                                       |
#| Unless otherwise contractually defined, this IP code is licensed      |
#| exclusively for the target design environment it was provided for     |
#| by Cadence. The code may be modified for maintenance purposes due     |
#| to changes in the target design environment.                          |
#|                                                                       |
#| This code remains Cadence intellectual property and may under no      |
#| circumstances be given to third parties, neither in original nor in   |
#| modified versions, without Cadence's explicit written permission.     |
#|                                                                       |
#| PROPRIETARY INFORMATION, PROPERTY OF CADENCE DESIGN SYSTEMS, INC.     |
#|                                                                       |
#|-----------------------------------------------------------------------|
#$Id: gtc.tcl,v 1.5 2018/04/10 00:09:35 ctai Exp $
#####----------------------------------------
##### Usage: (this will not be needed after integration)
#####   1) Add the following to the main Liberate run script:
#####        To beginning of script:
#####          source <path>/gtc.tcl
#####          gtc_pre
#####        To end of script:
#####          gtc_post
#####   2) Run Liberate as you would normally do.
#####----------------------------------------
##### Procedure to generate testcase
#####   1) Copy model files
#####      - copy model file defined by liberate variable "extsim_model_include"
#####      - traverse all model files and copy include models
#####      - update model file path to copied model location
#####   2) Copy netlist
#####      - copy netlists defined in "read_spice" command
#####      - traverse all netlist and copy include netlists
#####      - update include file to copied netlist location
#####   3) Copy scripts, userdata files
#####      - get and copy all TCL scripts from "source" command
#####      - process all scripts and replace "source" with copied script location
#####----------------------------------------
##### Limitations:
#####   1) Procedure gtc_post will modify copied scripts and replace commands with new copied script location
#####      But if command (such as source, write_library, etc...) are executed using eval, or placed within if blocks,
#####      procedure does not trace through nested commands; thus manual update will be needed.
#####      Warning message are in both log and copied scripts for these conditions.
#####----------------------------------------
##### Global Variables:
#####   gtc_dir = testcase directory containing all files; sub_dir=tcl, model, netlist
#####   gtc_sedList(<filename>) = { {<frameInfo>} ... }
#####   gtc_fileMap(<srcFile>) = <destFile>
#####----------------------------------------
##### Notes:
#####   1) When script traverse link, the copied file retain the link's final destination file name
#####----------------------------------------
proc gtc_pre {} {
    global gtc_dir gtc_sedList gtc_fileMap
    set procName [lindex [info frame 0] end-2]

    ## Initialize variables
    if {![info exists gtc_dir] } { set gtc_dir "./testcase" }
    array set gtc_sedList {}
    array set gtc_fileMap {}
    puts "INFO: Generate Testcase enabled."
   

    #####----------------------------------------
    ##### Remap command - source
    #####----------------------------------------
    rename ::source ::gtc_orig_source
    proc ::source args {
	global gtc_dir gtc_sedList
	set procName [lindex [info frame 0] end-2]
	set DEBUG 0
	
	# get callScript info
	set frameInfo [info frame -1]
	array set frameInfoArray $frameInfo
	if {$DEBUG} { puts "DEBUG($procName): frameInfo: $frameInfo" }
	if {[info exists frameInfoArray(file)]} {
	    set callScript $frameInfoArray(file)
	    set script $args
	    set scriptName [file tail $script]
	    
	    if {$DEBUG} {
		puts "DEBUG($procName):   script($args)"
		puts "DEBUG($procName):   callScript($callScript)"
		puts "DEBUG($procName):   info frame = [info frame]"
		for {set level -1} {$level >= [expr {1-[info frame]}]} {incr level -1} { 
		    puts "DEBUG($procName):     info frame $level = [info frame $level]"
		}
	    }
	    if { [file tail $callScript] eq "init.tcl" } {
		if {$DEBUG} { puts "DEBUG($procName):   skipping: callScript(${callScript})" }
	    } elseif { ![file exists $args] } {
		error "ERROR: File ($args) does not exist."
	    } else {
		## Copy file to testcase area
		set destFile [gtc_cp_file $args $gtc_dir/tcl]
		set destFile [string range $destFile [expr [string length $gtc_dir]+1] end]
		gtc_update_sedList $destFile
	    }
	}
	## run original command
	uplevel 1 ::gtc_orig_source $args
    }

    #####----------------------------------------
    ##### Remap command - set_var
    #####----------------------------------------
    rename ::set_var ::gtc_orig_set_var
    proc ::set_var args {
	global gtc_dir
	set procName [lindex [info frame 0] end-2]
	set DEBUG 0

	lassign $args varName srcFile
	if { $varName eq "extsim_model_include" } {
	    ## modify, write, and traverse model files to testcase area
	    set destFile [gtc_cp_spice_file $srcFile $gtc_dir/model]
	    if {$DEBUG} { 
		puts "DEBUG($procName):   srcFile($srcFile)"
		puts "                    destFile($destFile)"
	    }
	    gtc_update_sedList "model/[file tail $destFile]"
	}
	## run original command
	uplevel 1 ::gtc_orig_set_var $args
    }

    #####----------------------------------------
    ##### Remap command - read_spice
    #####----------------------------------------
    proc ::read_spice args {
	global gtc_dir
	set procName [lindex [info frame 0] end-2]
	set DEBUG 0
	
	set inArgs $args
	while {$inArgs != ""} {
	    set inField [lindex $inArgs 0]
	    set inArgs [lreplace $inArgs 0 0]
	    if {$DEBUG} { puts "DEBUG($procName): inField($inField) inArgs($inArgs)" }
	    if { $inField eq "-format" } {
		# set gtc_read_spice_format [lindex $inArgs 0]
		set inArgs [lreplace $inArgs 0 0]
		if {$DEBUG} { puts "DEBUG($procName):   Process option -format: inArgs($inArgs)" }
	    } else {
		set destFileList {}
		foreach srcFile_orig $inField {
		    set srcFile [gtc_traverse_link $srcFile_orig]
		    if {$DEBUG} { puts "DEBUG($procName): srcFile($srcFile)" }
		    if { ![file exists $srcFile] } {
			puts "WARNING: File ($srcFile) specified in read_spice command does not exist."
		    } else {
			if { [file exists "${gtc_dir}/model/[file tail $srcFile]"] } {
			    lappend destFileList "model/[file tail $srcFile]"
			} else {
			    ## If not model_include_file, traverse, modify, and copy netlist to testcase area
			    gtc_cp_spice_file $srcFile $gtc_dir/netlist
			    lappend destFileList "netlist/[file tail $srcFile]"
			}
		    }
		}
		gtc_update_sedList [list $destFileList]
	    }
	}
	return ok
    }

    #####----------------------------------------
    ##### Remap command - read_library
    #####----------------------------------------
    proc ::read_library args {
	global gtc_dir 
	## copy file
	set script $args
	set scriptName [file tail $script]
	set destFile $gtc_dir/lib/$scriptName
	set destFile [gtc_cp_file $script $destFile]
	set destFile [string range $destFile [expr [string length $gtc_dir]+1] end]
	gtc_update_sedList $destFile
	return ok
    }

    #####----------------------------------------
    ##### Remap command - write_library
    #####----------------------------------------
    proc ::write_library args {
	global gtc_dir
	set DEBUG 0
	
	set inArgs $args
	while {$inArgs!=""} {
	    set inField [lindex $inArgs 0]
	    set inArgs [lreplace $inArgs 0 0]
	    if { $inField eq "-user_data" } {
		set destFile [gtc_cp_file [lindex $inArgs 0] $gtc_dir/userdata]
		set destFile [string range $destFile [expr [string length $gtc_dir]+1] end]
		gtc_update_sedList $destFile
		return ok
	    }
	}
	return ok
    }

    #####----------------------------------------
    ##### Remap command - read_ldb
    #####----------------------------------------
    proc ::read_ldb args {
	global gtc_dir
	set destFile [gtc_cp_file [lindex $args 0] $gtc_dir/ldb]
	set destFile [string range $destFile [expr [string length $gtc_dir]+1] end]
	gtc_update_sedList $destFile
	return ok
    }

    #####----------------------------------------
    ##### Remap command - read_truth_table
    #####----------------------------------------
    proc ::read_truth_table args {
	global gtc_dir
	set destFile [gtc_cp_file [lindex $args 0] $gtc_dir/template]
	set destFile [string range $destFile [expr [string length $gtc_dir]+1] end]
	gtc_update_sedList $destFile
	return ok
    }

    #####----------------------------------------
    ##### Remap command - read_vdb
    #####----------------------------------------
    proc ::read_vdb args {
	global gtc_dir
	set destFile [gtc_cp_file [lindex $args 0] $gtc_dir/vdb]
	set destFile [string range $destFile [expr [string length $gtc_dir]+1] end]
	gtc_update_sedList $destFile
	return ok
    }

    #####----------------------------------------
    ##### Remap liberate commands to be ignored
    #####----------------------------------------
    set liberateIgnoreCmdList {
	define_leafcell define_variation
	char_library write_ldb
	char_variation write_variation write_variation_table write_socv
    }
    foreach cmd $liberateIgnoreCmdList {
	eval "proc ::$cmd args \{\}"
    }


    #####----------------------------------------
    ##### procedure to traverse, modify, and copy spice files
    #####----------------------------------------
    proc gtc_cp_spice_file {srcFile destDir} {
	global gtc_dir
	set procName [lindex [info frame 0] end-2]
	set DEBUG 0
	
	if {$DEBUG} { puts "DEBUG($procName): srcFile($srcFile) destDir($destDir)" }
	# set srcFile [file normalize $srcFile]
	set srcFile [gtc_traverse_link $srcFile]
	set rtnFile "${destDir}/[file tail $srcFile]"

	set srcFileList [list $srcFile]
	while { [llength $srcFileList] != 0 } {
	    set srcFile [gtc_traverse_link [lindex $srcFileList 0]]
	    # set fileName [file tail $srcFile]
	    if {$srcFile ne ""} {
		set srcDir [file dirname $srcFile]
		## read file to memory
		if {$DEBUG} { puts "DEBUG($procName): Read file($srcFile) to memory." }
		if { [catch {open $srcFile r} fp] } {
		    puts "WARNING: Unable to open source file ($srcFile)."
		} else {
		    set file_lines [split [read $fp [file size $srcFile]] \n]
		    close $fp
		}
		## process and write file
		# set destFile $destDir/$fileName
		set destFile "${destDir}/[file tail $srcFile]"
		if {$DEBUG} { puts "DEBUG($procName): Process and write destFile($destFile)." }
		if { [catch {open $destFile w} fp] } {
		    puts "WARNING: Unable to open file ($destFile) for write."
		} else {
		    puts "INFO: Writing file : $destFile"
		    set lineNum 1
		    foreach line $file_lines {
			if {$DEBUG>1} { puts "DEBUG($procName):   line($line)" }
			set line_head ""
			set include_file ""
			set line_tail ""
			if { [regexp {^ *(include|\.INC|\.inc|\.INCLUDE|\.include|\.LIB|\.lib) +[\"\'](\S+)[\"\'] *(.*)$} $line a line_head include_file line_tail] } {
			    if {$DEBUG} { puts "DEBUG($procName): line_head($line_head) include_file($include_file) line_tail($line_tail)" }
			    set include_file [string trim $include_file " \"\'"]    ;# remove quotes from $include_file
			    set include_fileName [file tail $include_file]
			    ## if include_file use environment variable, expand variable 
			    if { [regexp {^.*\$(\S*)(/.*)$} $include_file a env_var file_tail] } {
				if { ![info exists env($env_var)] } {
				    error "Undefined environment variable \$$env_var in file $srcFile"
				}
				set include_file env($env_var)/$file_tail
			    }
			    ## if include_file use relative path, convert to full path 
			    if { [string index $include_file 0] ne "/" } {
				set x "[file normalize $srcDir/$include_file]"
			    } else {
				set x $include_file
			    }
			    ## add to srcFileList - if file does not exist in $srcFileList and destination directory
			    if { ($x ni $srcFileList) && ($include_fileName ni [glob -directory $destDir *])} {
				lappend srcFileList $x
				if {$DEBUG} { 
				    puts "DEBUG($procName):   Appended file($x) to srcFileList"
				    puts "                      srcFileList($srcFileList)" 
				}
			    }
			    ## update $line
			    if { ($include_fileName ne $include_file) && ($include_fileName ne "./$include_file") } {
				set line "* $line"
				puts $fp "$line_head \"[file tail $include_file]\" $line_tail"
			    }
			}
			puts $fp $line
			incr lineNum
		    }
		    close $fp
		}
	    }
	    set srcFileList [lreplace $srcFileList 0 0]
	    if {$DEBUG} {puts "DEBUG($procName): srcFileList($srcFileList)"}
	} ;# while $srcFileList
	if {$DEBUG} {puts "DEBUG($procName): rtnFile($rtnFile)"}
	return $rtnFile
    }


    #####----------------------------------------
    ##### procedure to copy file
    #####   Check array $gtc_mapFile(<$srcFile>) to see if file has been previously copied
    #####   Create $destDir if it doesn't exists
    #####   Rename file to "$srcFile.#" if file already exists
    #####   Append to $gtc_mapFile
    #####----------------------------------------
    proc gtc_cp_file {srcFile destDir} {
	global gtc_fileMap
	set procName [lindex [info frame 0] end-2]
	set DEBUG 0
	
	## Check procedure inputs
	if { ![file isfile $srcFile] } {
	    puts "ERROR($procName): 1st input field ($srcFile) should be a file."
	    exit 1
	}
	if { ![file exists $srcFile] } {
	    puts "ERROR($procName): srcFile($srcFile) does not exist or not readable."
	    exit 1
	}

	# set srcFile [file normalize $srcFile]
	set srcFile [gtc_traverse_link $srcFile]
	if {$srcFile ne ""} {
	    set srcFileName [file tail $srcFile]
	    set destFile $destDir/$srcFileName
	    ## check if srcFile has been copied before
	    if { ![info exists gtc_fileMap($srcFile)] } {
		## create $destDir if it doesn't exists
		if { ![file exists $destDir] } { file mkdir $destDir }
		## add file extention of .# to $destFile if file exists already
		set destFileNew $destFile
		set i 0
		while { [file exists $destFileNew] } {
		    incr i
		    set destFileNew "$destFile.$i"
		}
		set destFile $destFileNew
		## copy file
		if { [catch "file copy $srcFile $destFile"] } {
		    puts "ERROR($procName): Unable to copy file $srcFile to $destFile."
		} else {
		    puts "INFO: Copying file $srcFile to  $destFile"
		    ## update $gtc_mapFile
		    set gtc_fileMap($srcFile) $destFile
		}
	    } else {
		set destFile $gtc_fileMap($srcFile)
	    }
	}
	return $destFile
    }

    #####----------------------------------------
    ##### procedure to traverse UNIX file links recursively
    #####   no need to check for looping links because [info exists <file>]=0 for looping links
    #####----------------------------------------
    proc gtc_traverse_link {file} {
	set procName [lindex [info frame 0] end-2]
	set DEBUG 0

	set srcFile $file
	set srcFileList {}
	if {![catch {file readlink $srcFile} fid]} {
	    ## if srcFile is a link
	    while {![catch {file readlink $srcFile} fid]} {
		set resultFile($srcFile) [file readlink $srcFile]
		# add path if link is relative
		if { [file pathtype $resultFile($srcFile)] eq "relative" } {
		    set resultFile($srcFile) "[file dirname $srcFile]/$resultFile($srcFile)"
		}
		if {$DEBUG} {puts "DEBUG($procName): srcFile=$srcFile  resultFile=$resultFile($srcFile)"}
		lappend srcFileList $srcFile
		set srcFile $resultFile($srcFile)
	    }
	}
	if {$DEBUG} {
	    foreach x $srcFileList { puts "         $x -> $resultFile($x)" }  ;# print list of links
	}
	return $srcFile  ;# return final file link is pointing to
    }


    #####----------------------------------------
    ##### procedure to get call script/command info
    #####   Check array $gtc_mapFile(<$srcFile>) to see if file has been previously copied
    #####   Create $destDir if it doesn't exists
    #####   Rename file to "$srcFile.#" if file already exists
    #####   Append to $gtc_mapFile
    #####----------------------------------------
    proc gtc_update_sedList { {destFile ""} } {
	global gtc_sedList
	set procName [lindex [info frame 0] end-2]
	set DEBUG 0

	## get callScript info
	set frameLevel -2
	set status_getScriptName 0
	set frameInfo [info frame $frameLevel]
	array set frameInfoArray $frameInfo
	while { !$status_getScriptName } {
	    set frameInfo1 [info frame $frameLevel]
	    if {$DEBUG} { puts "DEBUG($procName): frameInfo1=$frameInfo1 " }
	    array set frameInfo1Array $frameInfo1
	    if { [info exists frameInfo1Array(file)] } {
		set frameInfoArray(file) $frameInfo1Array(file)
		set frameInfoArray(line) $frameInfo1Array(line)
		set callScriptName [file tail $frameInfo1Array(file)]
		set status_getScriptName 1
	    } else {
		incr frameLevel -1
	    }
	}
	## Update subtitution list
	if { $destFile ne "" } {
	    lappend gtc_sedList($callScriptName) "[array get frameInfoArray] destFile $destFile"
	} else {
	    lappend gtc_sedList($callScriptName) "[array get frameInfoArray]"
	}
	if {$DEBUG} { 
	    puts "DEBUG($procName): gtc_sedList($callScriptName) ="
	    foreach x $gtc_sedList($callScriptName) { puts "                    $x"}
	}

	return ok
    }


    ## Create testcase directory structure
    if { [file exists $gtc_dir] } { file delete -force $gtc_dir }
    file mkdir $gtc_dir/tcl $gtc_dir/netlist $gtc_dir/model

    ## copy source script
    upvar argv0 srcScript
    set fileName [file tail $srcScript]
    if { ![file exists $gtc_dir/tcl/$fileName] } {
    	file copy $srcScript $gtc_dir/tcl/$fileName
    }
}

proc gtc_post {} {
    global gtc_dir gtc_sedList
    set procName [lindex [info frame 0] end-2]
    set DEBUG 0

    ### Process gtc_sedList
    foreach fileName [array names gtc_sedList] {
	set file $gtc_dir/tcl/$fileName
	puts "INFO: Processing file : $file"
	## read file to memory
	if { [catch {open $file r} fp] } {
	    puts "WARNING: Unable to open file ($file)."
	} else {
	    set file_lines [split [read $fp [file size $file]] \n]
	    close $fp

	    ## modify file (in memory)
	    if {$DEBUG} { puts "DEBUG($procName):   gtc_sedList($fileName)=$gtc_sedList($fileName)" }
	    foreach frameInfo $gtc_sedList($fileName) {
		if {$DEBUG} { puts "DEBUG($procName): frameInfo=$frameInfo" }
		array set frameInfoArray $frameInfo
		set cmd0 [lindex $frameInfoArray(cmd) 0]
		## comment out old command line
		set lineNum [expr {$frameInfoArray(line) - 1}]
		set readNextLine 1
		while {$readNextLine} {
		    set line [lindex $file_lines $lineNum]
		    if { [regexp {^.*\\$} $line] } { 
			lset file_lines $lineNum "# $line"
			incr lineNum
		    } else {
			set readNextLine 0
		    }
		}
		## build final command line
		set line "# $line"
		if { ($frameInfoArray(type) eq "eval") } {
		    puts "WARNING: File($file) Line([expr $lineNum+1]) "
		    puts "         Modifying command within TCL command block (such as eval,if,etc...); manual update might be needed."
		    set line "$line\n# WARNING: Modifying command within TCL command block (such as eval, if, etc...); manual update might be needed."
		}
		if {$DEBUG} { puts "DEBUG($procName):     cmd0($cmd0)" }
		if { $cmd0 eq "write_library" } {
		    regexp {^(.*write_library.*)-user_data +\S+(.*)$} $frameInfoArray(cmd) a line_pre line_post
		    lset file_lines $lineNum "$line\n${line_pre}-user_data $frameInfoArray(destFile)${line_post}"
		} elseif { $cmd0 eq "set_var" } {
		    regexp "^(.\*)set_var +extsim_model_include +\\S+(.\*)$" $frameInfoArray(cmd) a line_pre line_post
		    lset file_lines $lineNum "$line\n${line_pre}set_var extsim_model_include \[file normalize $frameInfoArray(destFile)\]${line_post}"
		} elseif { $cmd0 eq "read_spice" } {
		    set line_pre [lrange $frameInfoArray(cmd) 0 end-1]
		    lset file_lines $lineNum "$line\n${line_pre} \{ $frameInfoArray(destFile) \}"

		} else {
		    regexp "^(.\*)$cmd0 +\\S+(.\*)$" $frameInfoArray(cmd) a line_pre line_post
		    lset file_lines $lineNum "$line\n${line_pre}${cmd0} $frameInfoArray(destFile)${line_post}"
		}
		if {$DEBUG} {
		    puts "DEBUG($procName):     new line:"
		    puts "[lindex $file_lines $lineNum]"
		}
	    } ;#foreach frameInfo
	    
	    ## write file
	    if { [catch {open $file w} fp] } {
		puts "WARNING: Unable to open file ($file) for write."
	    } else {
		set lineNum 1
		set i_array 0
		foreach line $file_lines {
		    if {$DEBUG} { puts "DEBUG($procName): line($lineNum) : $line" }
		    ## remove gtc calls - not needed after integration into Liberate
		    if {[regexp {^.*gtc_.+$} $line]} { set line "# $line" }
		    if {[regexp {^.*source.+gtc\.tcl.*$} $line]} { set line "# $line" }
		    ## print line
		    puts $fp $line
		    incr lineNum
		}
		close $fp
	    }
	}
    }
}
		       
