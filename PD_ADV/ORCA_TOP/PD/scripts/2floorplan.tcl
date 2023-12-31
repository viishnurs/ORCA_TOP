#code for  floorplanning after the importing the design
################################################
##############################################
#######   created by : VISHNU
#
############
#############  sanity checks #######3
#
####opening the library ######
#
#
#
open_lib ./outputs/work/ORCA_TOP.nlib
list_blocks
open_block import_design
link_block 
start_gui


#############  sanity checks #######3

check_netlist
check_mv_design
check_timing
report_ref_libs
report_timing
#check_design_mismatch


######## estimating the area of core
#
source ./scripts/netlish_area_estimation.tcl

netlist_area 0.8


######## CREATING THE CORE AND DIE PLAN#################3
########## initilize the floorplan ###########


initialize_floorplan -core_utilization 0.8 -side_ratio 1 -flip_first_row true -site_def unit -use_site_row -core_offset 5

############# port_placement#####
#

remove_block_pin_constraints
#
set_individual_pin_constraints -ports [all_inputs ] -sides 1 -allowed_layers {M5 M3} -pin_spacing 5

remove_individual_pin_constraints

set_block_pin_constraints -sides 1 -pin_spacing 5 -allowed_layers {M5 M3} -corner_keepout_distance 100 -self


place_pins -ports [all_inputs ]

#
#
#:::
#
############# clk pins 
remove_block_pin_constraints

set_individual_pin_constraints -ports [get_ports *clk* ] -sides 2 -allowed_layers {M4 M6} -pin_spacing 5

remove_individual_pin_constraints

set_block_pin_constraints -sides 2 -pin_spacing 5 -allowed_layers {M4 M6} -corner_keepout_distance 100 -self 
	
place_pins -ports [get_ports *clk*]
#
#
#
#
#
############# output pins 
remove_block_pin_constraints


set_individual_pin_constraints -ports [all_outputs ] -sides 3 -allowed_layers {M5 M3} -pin_spacing 5

remove_individual_pin_constraints

set_block_pin_constraints -sides 3 -pin_spacing 5 -allowed_layers {M5 M3} -corner_keepout_distance 100 -self 

place_pins -ports [all_outputs ]




list_blocks


##########################################################################
############## ADDING MACROS INSIDE THE CORE AREA					##################
######################################################################################

set_app_options -list {plan.macro.grouping_by_hierarchy true plan.macro.macro_place_only true plan.place.auto_create_blockages none }
source ./scripts/auto_macro_placement.tcl
create_placement -floorplan






load_upf ./inputs/ORCA_TOP.upf

report_power_domains

commit_upf

save_block -as floorplanning_main


###########   and place  placement_blockage inside core area 

####### after placemtn use vol_area_creation.tcl 
#############3 AFTER THAT USE boundary_tap.tcl 



######## BOUNDARY CELLS 


####### TAP CELLS



########## SANITY CHECKS 
#check_mv_design
#report_utilization
