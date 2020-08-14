extends Node

#class_name T_slice

var slice_range = Rect2();
var eqn = null;
var draw_pts = [];
var draw_n = 8;
var dirty = true;

enum {X, Y}


func init(dbd_slice, y_start):
	slice_range.position[X] = dbd_slice["SLICE_X"];
	slice_range.position[Y] = y_start;
	slice_range.size[X] = dbd_slice["SLICE_WIDTH"];
	slice_range.size[Y] = slice_range.size[X];
	
	set_eqn(dbd_slice);


func set_eqn(dbd_slice):
	eqn = EquationMgr.T_equation.instance();
	
	eqn.DISPLAY_TEMPLATE = dbd_slice["DISPLAY_TEMPLATE"];
	eqn.DISPLAY_NAME = dbd_slice["DISPLAY_NAME"];
	eqn.EQN_Y_EQUALS = dbd_slice["Y_EQUALS"];
	eqn.N_PTS_BIAS_MULTIPLIER = dbd_slice["N_PTS_BIAS_MULTIPLIER"];
	eqn.PARITY = dbd_slice["PARITY"];
	eqn.IS_NORMALIZED = dbd_slice["IS_NORMALIZED"];
	eqn.TRUNCATE_RANGE = Vector2(dbd_slice["TRUNCATE_RANGE_X"], dbd_slice["TRUNCATE_RANGE_WIDTH"]);
	
	var p_names = dbd_slice["PARAM_NAMES"].split(",", false);
	var p_values = dbd_slice["PARAM_VALUES"].split(",", false);
	
	var p_dict = {  };
	for i in range(p_names.size()):
		p_dict[p_names[i]] = float(p_values[i]);
	
	eqn.EQN_PARAM_DEFAULTS = p_dict;
	
	eqn.set_params_to_default();
	


func call_fn(x):
	eqn.y.call_func(x);

func end_y():
	return slice_range.size[Y] * eqn.y(1) + slice_range.position[Y];

func range_min_x():
	return slice_range.position[X];

func range_min_y():
	return slice_range.position[Y];

func range_max_x():
	return slice_range.position[X] + slice_range.size[X];

func range_max_y():
	return slice_range.position[Y] + slice_range.size[Y];

func get_marker_min_coords():
	#TODO
	pass;

func get_marker_max_coords():
	#TODO
	pass;


# includes slice location/size
func get_draw_points(n_pts):
	if ((n_pts != draw_n) || (dirty) || (eqn.dirty)):
		draw_n = n_pts;
		make_draw_points(eqn.get_n_pts(n_pts));
	
	return draw_pts;


# TODO: Move most of this to T_equaution
# then eqn is only "dirty" if draw_n or the equation changes
# and slice just fits draw_pts to the slice size
func make_draw_points(eqn_pts):
	if (eqn.IS_NORMALIZED):
		#multiply by slice size
		#offset by slice position
		pass;
	else:
		#multiply by (slice size / truncate_size)
		#offset by negative truncate_position, then slice position
		pass;
	
	
	#OLD CODE
	#var xy = Vector2(0,0);
	#if (eqn.IS_NORMALIZED || (!eqn.IS_NORMALIZED && eqn.TRUNCATE_RANGE[X] == 0)):
	#	xy[X] *= slice_range.size[X];
	#	xy[X] += slice_range.position[X];
	#	
	#	xy[Y] *= slice_range.size[Y];
	#	xy[Y] += slice_range.position[Y];
	#else:
	#	#TODO: need to subtract starting x from each 
	
	# draw_pts = something
	
	dirty = false;
