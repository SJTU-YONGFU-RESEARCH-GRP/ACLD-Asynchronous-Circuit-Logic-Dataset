
# define_variation commands

set sigma 1.0 

define_variation -type random {rn1 1} rn1
define_variation -type random {rn2 1} rn2
define_variation -type random {rp1 1} rp1
define_variation -type random {rp2 1} rp2
#
set var_parameter_list [list rn1 rn2 rp1 rp2] 
   
set_var variation_sigma $sigma 
define_variation_factor {delay 3.0 constraint 3.0}
set sigma_factor [expr 1.0 / $sigma]

define_variation_group -sigma_factor $sigma_factor $var_parameter_list LOCAL_VARIATION

define_variation_average -min_factor 0.0 -max_factor 1.0 -random simple_pos_is_max

