define_cell \
       -input { A B } \
       -output { Y } \
       -pinlist { A B Y } \
       -delay delay_template_7x7_4 \
       -power power_template_7x7_4 \
       XOR2X1

define_leakage -when "A&B" XOR2X1
define_leakage -when "A&!B" XOR2X1
define_leakage -when "!A&B" XOR2X1
define_leakage -when "!A&!B" XOR2X1

# delay arcs from A => Y positive_unate combinational
define_arc \
       -when "!B" \
       -vector {RxR} \
       -related_pin A \
       -pin Y \
       -sdf_cond "B == 1'b0" \
       XOR2X1

# delay arcs from A => Y positive_unate combinational
define_arc \
       -when "!B" \
       -vector {FxF} \
       -related_pin A \
       -pin Y \
       -sdf_cond "B == 1'b0" \
       XOR2X1

define_arc \
       -when "B" \
       -vector {FxR} \
       -related_pin A \
       -pin Y \
       -sdf_cond "B == 1'b1" \
       XOR2X1

define_arc \
       -when "B" \
       -vector {RxF} \
       -related_pin A \
       -pin Y \
       -sdf_cond "B == 1'b1" \
       XOR2X1

# delay arcs from B => Y positive_unate combinational
define_arc \
       -when "!A" \
       -vector {xRR} \
       -related_pin B \
       -pin Y \
       -sdf_cond "A == 1'b0" \
       XOR2X1

# delay arcs from B => Y positive_unate combinational
define_arc \
       -when "!A" \
       -vector {xFF} \
       -related_pin B \
       -pin Y \
       -sdf_cond "A == 1'b0" \
       XOR2X1

define_arc \
       -when "A" \
       -vector {xFR} \
       -related_pin B \
       -pin Y \
       -sdf_cond "A == 1'b1" \
       XOR2X1

define_arc \
       -when "A" \
       -vector {xRF} \
       -related_pin B \
       -pin Y \
       -sdf_cond "A == 1'b1" \
       XOR2X1

