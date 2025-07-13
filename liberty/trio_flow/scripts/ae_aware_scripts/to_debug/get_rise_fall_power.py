###############################################################################
#  DISCLAIMER: The following code is provided for Cadence customers to use at  #
#   their own risk. The code may require modification to satisfy the           #
#   requirements of any user. The code and any modifications to the code may   #
#   not be compatible with current or future versions of Cadence products.     #
#   THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING WITHOUT     #
#   LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES OF MERCHANTABILITY #
#   OR FITNESS FOR A PARTICULAR USE.                                           #
################################################################################

################################################################################################
# Usage : get_rise_fall_power.py <input_lib> <output_lib> 
# Script will use input_lib and write out output_lib with sum of rise_power and fall_power values
# Both rise_power and fall_power tables will have identical values (sum) in output_lib
################################################################################################

import sys
import re
import inspect
import numpy as np
import os
import statistics
import ldbx

def sum_rise_fall_power(lib):
    funcname = inspect.stack()[0][3]
    print("\n################## Running " + funcname + " ################")
    # instantiate an ArcCollection object from lib
    arcCol = ldbx.ArcCollection(lib)
    cells = lib.getChildren('cell')
    for cell in cells:
        cellName = cell.getName()
        #print('Cell Name ' + cellName )
        pins = cell.getChildren('pin')
        for pin in pins:
            pinName = pin.getName()
            #print('Pin Name ' + pinName)
            power_groups = arcCol.getGroups(cells = [cellName], groupHeaderName = ('internal_power','.*'), kvlist = [('pin',pinName)])
             
            for group in power_groups:
                identifier = group.getIdentifier()
                groupName = group.getGroup().getHeader()
                #print('Group Name ' + groupName + ' Identifier : ' + str(identifier))
                arcs = arcCol.getArcs(cells = [cellName], kvlist = identifier)
                for arc in arcs:
                    arc_id = arc.getIdentifier()
                    def key_array(arc_id):
                        return arc_id[0]
                    #print('Arc ID : ' + str(arc_id)) 
                    arcMap = set(map(key_array,arc_id))
                    #print('Arc : ' + str(arc) )
                    #print('Values : ' + str(arc.getTable().getValue()))
                    if 'rise_power' in arcMap:
                       rise_power_array = arc.getTableArray()
                    if 'fall_power' in arcMap:
                       fall_power_array = arc.getTableArray()
                newtable_array = rise_power_array + fall_power_array
                for arc in arcs:
                    arc.setTableArray(newtable_array)
                    #print('Updating table values for' + str(arc) + ' with values : ' + str(arc.getTable().getValue()))
                                    
def main(argv): 
    if len(sys.argv) != 3:
       print('Correct usage is : get_rise_fall_power.py <input_lib> <output_lib>')
    inputLib = sys.argv[1]
    outputLib = sys.argv[2]
    print('Input lib is : ' + inputLib)  
    print('Output lib is : ' + outputLib)  
    in_lib = ldbx.read_db(inputLib) 
    sum_rise_fall_power(in_lib)
    in_lib.writeDb (outputLib, False, True)

main(sys.argv[1:])
