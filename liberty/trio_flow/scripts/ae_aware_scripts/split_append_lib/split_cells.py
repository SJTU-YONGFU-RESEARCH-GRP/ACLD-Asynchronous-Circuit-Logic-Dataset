import ldbx
import sys
import time

def write_cell_to_lib(lib_in, cell):
    copied = lib_in.copyGroup(cell)
    lib_name = copied.getName() + ".lib"
    print("INFO (", time.ctime(), "): Writing cell (", copied.getName(), ") into .lib file...")
    lib_in.writeDb(lib_name)
    print("INFO (", time.ctime(), "): Finished writing cell (", copied.getName(), ") into .lib file.")
    lib_in.delGroup([copied])


lib_file = sys.argv[1]
cells_list = []
if len(sys.argv) > 2:
    cells_list = sys.argv[2]

print("INFO (", time.ctime(), "): Reading in the library...")

lib_in = ldbx.read_db(lib_file)

print("INFO (", time.ctime(), "): Finished reading in the library.")

lib_temp = ldbx.create_db("temp")

cell_grps = lib_in.getChildren("cell")
for cell in cell_grps:
    lib_temp.copyGroup(cell)

lib_in.delGroup(cell_grps)

cell_grps_temp = lib_temp.getChildren("cell")

for cell in cell_grps_temp:
    if cells_list:
        if cell.getName() in cells_list:
            write_cell_to_lib(lib_in, cell)
        else:
            print("INFO (", time.ctime(), "): cell (", cell.getName(), ") is not in the cell list user defined.")
    else:
        write_cell_to_lib(lib_in, cell)

