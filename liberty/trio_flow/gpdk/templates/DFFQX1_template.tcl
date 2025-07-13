define_cell \
       -clock { CK } \
       -input { D } \
       -output { Q } \
       -pinlist { CK D Q } \
       -delay delay_template_7x7_1 \
       -power power_template_7x7_1 \
       -constraint constraint_template_5x5 \
       -mpw mpw_template_5x1 \
       DFFQX1

define_leakage -when "CK&D" DFFQX1
define_leakage -when "CK&!D" DFFQX1
define_leakage -when "!CK&D" DFFQX1
define_leakage -when "!CK&!D" DFFQX1

# power arcs from  => CK  hidden
define_arc \
       -type hidden \
       -when "D&Q" \
       -vector {Rxx} \
       -pin CK \
       DFFQX1

# power arcs from  => CK  hidden
define_arc \
       -type hidden \
       -when "D&Q" \
       -vector {Fxx} \
       -pin CK \
       DFFQX1

define_arc \
       -type hidden \
       -when "D&!Q" \
       -vector {Fxx} \
       -pin CK \
       DFFQX1

define_arc \
       -type hidden \
       -when "!D&Q" \
       -vector {Fxx} \
       -pin CK \
       DFFQX1

define_arc \
       -type hidden \
       -when "!D&!Q" \
       -vector {Rxx} \
       -pin CK \
       DFFQX1

define_arc \
       -type hidden \
       -when "!D&!Q" \
       -vector {Fxx} \
       -pin CK \
       DFFQX1

# constraint arcs from CK => CK  min_pulse_width
define_arc \
       -type min_pulse_width \
       -when "D" \
       -vector {Rxx} \
       -related_pin CK \
       -pin CK \
       -sdf_cond "ENABLE_D == 1'b1" \
       DFFQX1

# constraint arcs from CK => CK  min_pulse_width
define_arc \
       -type min_pulse_width \
       -when "D" \
       -vector {Fxx} \
       -related_pin CK \
       -pin CK \
       -sdf_cond "ENABLE_D == 1'b1" \
       DFFQX1

define_arc \
       -type min_pulse_width \
       -when "!D" \
       -vector {Rxx} \
       -related_pin CK \
       -pin CK \
       -sdf_cond "ENABLE_NOT_D == 1'b1" \
       DFFQX1

define_arc \
       -type min_pulse_width \
       -when "!D" \
       -vector {Fxx} \
       -related_pin CK \
       -pin CK \
       -sdf_cond "ENABLE_NOT_D == 1'b1" \
       DFFQX1

# power arcs from  => D  hidden
define_arc \
       -type hidden \
       -when "CK" \
       -vector {xRx} \
       -pin D \
       DFFQX1

# power arcs from  => D  hidden
define_arc \
       -type hidden \
       -when "CK" \
       -vector {xFx} \
       -pin D \
       DFFQX1

define_arc \
       -type hidden \
       -when "!CK&Q" \
       -vector {xRx} \
       -pin D \
       DFFQX1

define_arc \
       -type hidden \
       -when "!CK&Q" \
       -vector {xFx} \
       -pin D \
       DFFQX1

define_arc \
       -type hidden \
       -when "!CK&!Q" \
       -vector {xRx} \
       -pin D \
       DFFQX1

define_arc \
       -type hidden \
       -when "!CK&!Q" \
       -vector {xFx} \
       -pin D \
       DFFQX1

# constraint arcs from CK => D  hold_rising
define_arc \
       -type hold \
       -vector {RRx} \
       -related_pin CK \
       -pin D \
       DFFQX1

# constraint arcs from CK => D  hold_rising
define_arc \
       -type hold \
       -vector {RFx} \
       -related_pin CK \
       -pin D \
       DFFQX1

define_arc \
       -type setup \
       -vector {RRx} \
       -related_pin CK \
       -pin D \
       DFFQX1

define_arc \
       -type setup \
       -vector {RFx} \
       -related_pin CK \
       -pin D \
       DFFQX1

# delay arcs from CK => Q non_unate rising_edge
define_arc \
       -type edge \
       -vector {RxR} \
       -related_pin CK \
       -pin Q \
       DFFQX1

# delay arcs from CK => Q non_unate rising_edge
define_arc \
       -type edge \
       -vector {RxF} \
       -related_pin CK \
       -pin Q \
       DFFQX1

