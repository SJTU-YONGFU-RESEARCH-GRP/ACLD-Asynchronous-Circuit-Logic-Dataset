
read_library {orig_libs/ts05nxqllogl06hdl051f_ffgnp1p045v125c_lvf.lib.gz}

source ./cln4/cells.tcl


set_var user_data_quote_attributes {
restore_action \
restore_condition \
restore_edge_type \
save_action \
save_condition \
}

set attributes { \
always_on \
area \
cell_footprint \
clear \
clear_preset_var1 \
clear_preset_var2 \
clock \
clocked_on \
clock_gate_clock_pin \
clock_gate_enable_pin \
clock_gate_out_pin \
clock_gate_test_pin \
clock_gating_integrated_cell \
contention_condition \
data_in \
default_inout_pin_cap \
default_input_pin_cap \
default_leakage_power_density \
default_wire_load \
default_wire_load_mode \
direction \
dont_touch \
dont_use \
enable \
function \
input \
input_map \
input_voltage_range \
interface_timing \
internal_node \
inverted_output \
is_clock_cell \
is_isolated \
is_isolation_cell \
is_level_shifter \
is_macro_cell \
is_memory_cell \
isolation_cell_data_pin \
isolation_cell_enable_pin \
isolation_enable_condition \
level_shifter_data_pin \
level_shifter_enable_pin \
level_shifter_type \
library_features \
members \
next_state \
nextstate_type \
output_voltage_range \
pin_func_type \
power_down_function \
preset \
required_condition \
restore_action \
restore_condition \
restore_edge_type \
retention_cell \
retention_pin \
save_action \
save_condition \
signal_type \
state_function \
std_cell_main_rail \
switch_cell_type \
switch_pin \
table \
three_state \
user_function_class \
x_function \
}

set groups { \
clear_condition \
clock_condition \
ff \
ff_bank \
latch \
latch_bank \
memory \
memory_read \
memory_write \
pg_pin \
preset_condition \
retention_condition \
statetable \
test_cell \
wire_load \
}

write_userdata_library -include_attributes {default input_map internal_node state_function statetable function} -include_groups {default pin bundle} -cells $cells user_data.lib 


