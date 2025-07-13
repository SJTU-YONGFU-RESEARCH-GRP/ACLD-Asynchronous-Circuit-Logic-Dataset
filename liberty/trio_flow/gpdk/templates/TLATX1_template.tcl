define_cell \
       -clock { G } \
       -input { D } \
       -output { Q QN } \
       -pinlist { D G Q QN } \
       -delay delay_template_7x7_3 \
       -power power_template_7x7_3 \
       -constraint constraint_template_5x5 \
       -mpw mpw_template_5x1 \
       TLATX1

define_index -pin QN -related_pin D -type {delay power} \
         -index_1 {0.012 0.0217033 0.0392528 0.070993 0.128398 0.232223 0.42 } \
         -index_2 {0.0001 0.000311589 0.000778972 0.00194743 0.00486858 0.0121714 0.0304286 } \
       TLATX1

define_index -pin QN -related_pin G -type {delay power} \
         -index_1 {0.012 0.0217033 0.0392528 0.070993 0.128398 0.232223 0.42 } \
         -index_2 {0.0001 0.000311589 0.000778972 0.00194743 0.00486858 0.0121714 0.0304286 } \
       TLATX1

define_leakage -when "D&G" TLATX1
define_leakage -when "D&!G" TLATX1
define_leakage -when "!D&G" TLATX1
define_leakage -when "!D&!G" TLATX1

# power arcs from  => D  hidden
define_arc \
       -type hidden \
       -when "!G&Q&!QN" \
       -vector {Rxxx} \
       -pin D \
       TLATX1

# power arcs from  => D  hidden
define_arc \
       -type hidden \
       -when "!G&Q&!QN" \
       -vector {Fxxx} \
       -pin D \
       TLATX1

define_arc \
       -type hidden \
       -when "!G&!Q&QN" \
       -vector {Rxxx} \
       -pin D \
       TLATX1

define_arc \
       -type hidden \
       -when "!G&!Q&QN" \
       -vector {Fxxx} \
       -pin D \
       TLATX1

# constraint arcs from G => D  hold_falling
define_arc \
       -type hold \
       -vector {RFxx} \
       -related_pin G \
       -pin D \
       TLATX1

# constraint arcs from G => D  hold_falling
define_arc \
       -type hold \
       -vector {FFxx} \
       -related_pin G \
       -pin D \
       TLATX1

define_arc \
       -type setup \
       -vector {RFxx} \
       -related_pin G \
       -pin D \
       TLATX1

define_arc \
       -type setup \
       -vector {FFxx} \
       -related_pin G \
       -pin D \
       TLATX1

# power arcs from  => G  hidden
define_arc \
       -type hidden \
       -when "D&Q&!QN" \
       -vector {xRxx} \
       -pin G \
       TLATX1

# power arcs from  => G  hidden
define_arc \
       -type hidden \
       -when "D&Q&!QN" \
       -vector {xFxx} \
       -pin G \
       TLATX1

define_arc \
       -type hidden \
       -when "!D&!Q&QN" \
       -vector {xRxx} \
       -pin G \
       TLATX1

define_arc \
       -type hidden \
       -when "!D&!Q&QN" \
       -vector {xFxx} \
       -pin G \
       TLATX1

# constraint arcs from G => G  min_pulse_width
define_arc \
       -type min_pulse_width \
       -when "D" \
       -vector {xRxx} \
       -related_pin G \
       -pin G \
       -sdf_cond "ENABLE_D == 1'b1" \
       TLATX1

# constraint arcs from G => G  min_pulse_width
define_arc \
       -type min_pulse_width \
       -when "!D" \
       -vector {xRxx} \
       -related_pin G \
       -pin G \
       -sdf_cond "ENABLE_NOT_D == 1'b1" \
       TLATX1

# delay arcs from D => Q positive_unate combinational
define_arc \
       -vector {RxRx} \
       -related_pin D \
       -pin Q \
       TLATX1

# delay arcs from D => Q positive_unate combinational
define_arc \
       -vector {FxFx} \
       -related_pin D \
       -pin Q \
       TLATX1

# delay arcs from G => Q non_unate rising_edge
define_arc \
       -type edge \
       -vector {xRRx} \
       -related_pin G \
       -pin Q \
       TLATX1

# delay arcs from G => Q non_unate rising_edge
define_arc \
       -type edge \
       -vector {xRFx} \
       -related_pin G \
       -pin Q \
       TLATX1

# delay arcs from D => QN negative_unate combinational
define_arc \
       -vector {FxxR} \
       -related_pin D \
       -pin QN \
       TLATX1

# delay arcs from D => QN negative_unate combinational
define_arc \
       -vector {RxxF} \
       -related_pin D \
       -pin QN \
       TLATX1

# delay arcs from G => QN non_unate rising_edge
define_arc \
       -type edge \
       -vector {xRxR} \
       -related_pin G \
       -pin QN \
       TLATX1

# delay arcs from G => QN non_unate rising_edge
define_arc \
       -type edge \
       -vector {xRxF} \
       -related_pin G \
       -pin QN \
       TLATX1

