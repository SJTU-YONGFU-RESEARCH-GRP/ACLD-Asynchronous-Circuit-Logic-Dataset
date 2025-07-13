define_cell \
       -input { A B } \
       -output { Y } \
       -pinlist { A B Y } \
       -delay delay_template_7x7 \
       -power power_template_7x7 \
       AND2X1

define_leakage -when "A&B" AND2X1
define_leakage -when "A&!B" AND2X1
define_leakage -when "!A&B" AND2X1
define_leakage -when "!A&!B" AND2X1

# power arcs from  => A  hidden
define_arc \
       -type hidden \
       -when "!B&!Y" \
       -vector {Rxx} \
       -pin A \
       AND2X1

# power arcs from  => A  hidden
define_arc \
       -type hidden \
       -when "!B&!Y" \
       -vector {Fxx} \
       -pin A \
       AND2X1

# power arcs from  => B  hidden
define_arc \
       -type hidden \
       -when "!A&!Y" \
       -vector {xRx} \
       -pin B \
       AND2X1

# power arcs from  => B  hidden
define_arc \
       -type hidden \
       -when "!A&!Y" \
       -vector {xFx} \
       -pin B \
       AND2X1

# delay arcs from A => Y positive_unate combinational
define_arc \
       -vector {RxR} \
       -related_pin A \
       -pin Y \
       AND2X1

# delay arcs from A => Y positive_unate combinational
define_arc \
       -vector {FxF} \
       -related_pin A \
       -pin Y \
       AND2X1

# delay arcs from B => Y positive_unate combinational
define_arc \
       -vector {xRR} \
       -related_pin B \
       -pin Y \
       AND2X1

# delay arcs from B => Y positive_unate combinational
define_arc \
       -vector {xFF} \
       -related_pin B \
       -pin Y \
       AND2X1

