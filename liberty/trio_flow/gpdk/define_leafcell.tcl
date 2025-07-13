# define leaf cell
# ## Likely candidates for 4-port MOS devices
define_leafcell -type nmos -pin_position {0 1 2 3} { g45n1lvt g45n1svt g45n1hvt g45n2svt g45n1nvt g45n2nvt }
define_leafcell -type pmos -pin_position {0 1 2 3} { g45p1lvt g45p1svt g45p1hvt g45p2svt }
define_leafcell -type diode -pin_position {0 1} { g45nd1svt g45pd1svt }
