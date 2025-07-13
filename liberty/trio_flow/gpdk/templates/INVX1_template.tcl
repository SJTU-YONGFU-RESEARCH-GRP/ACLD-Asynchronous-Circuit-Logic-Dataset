define_cell \
       -input { A } \
       -output { Y } \
       -pinlist { A Y } \
       -delay delay_template_7x7_2 \
       -power power_template_7x7_2 \
       INVX1

define_leakage -when "A" INVX1
define_leakage -when "!A" INVX1

# delay arcs from A => Y negative_unate combinational
define_arc \
       -vector {FR} \
       -related_pin A \
       -pin Y \
       INVX1

# delay arcs from A => Y negative_unate combinational
define_arc \
       -vector {RF} \
       -related_pin A \
       -pin Y \
       INVX1

