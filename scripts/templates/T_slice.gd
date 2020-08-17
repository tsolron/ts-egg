extends Node


var slice_range := Transform2D();
var eqn = null;
var slice_pts_list := PoolVector2Array();
var draw_n := 8;
var dirty := true;
var prev_slice = null;
var next_slice = null;
var left_connection := Vector2(0.0, 0.0);
var right_connection := Vector2(0.0, 1.0);

enum {X, Y}


func init(dbd_slice):
	slice_range.origin.x = dbd_slice["SLICE_X"];
	slice_range.origin.y = 0.0;
	slice_range.x.x = dbd_slice["SLICE_WIDTH"];
	slice_range.y.y = slice_range.x.x;
	
	set_eqn(dbd_slice);
	
	update_slice_y_offset();
	
	#TODO: Will need to update these on eqn updates
	#      Specifically equation_range and eqn_params
	left_connection = eqn.n_pts_list[0];
	right_connection = eqn.n_pts_list[eqn.n_pts_list.size()-1];


func set_eqn(dbd_slice):
	eqn = EquationMgr.T_equation.instance();
	
	eqn.DISPLAY_TEMPLATE = dbd_slice["DISPLAY_TEMPLATE"];
	eqn.DISPLAY_NAME = dbd_slice["DISPLAY_NAME"];
	eqn.EQN_Y_EQUALS = dbd_slice["Y_EQUALS"];
	eqn.N_PTS_BIAS_MULTIPLIER = dbd_slice["N_PTS_BIAS_MULTIPLIER"];
	eqn.PARITY = dbd_slice["PARITY"];
	eqn.IS_NORMALIZED = dbd_slice["IS_NORMALIZED"];
	eqn.TRUNCATE_RANGE = Vector2(dbd_slice["TRUNCATE_RANGE_X"],dbd_slice["TRUNCATE_RANGE_WIDTH"]);
	
	var p_names = dbd_slice["PARAM_NAMES"].split(",", false);
	var p_values = dbd_slice["PARAM_VALUES"].split(",", false);
	var p_dict = {  };
	for i in range(p_names.size()):
		p_dict[p_names[i]] = float(p_values[i]);
	eqn.EQN_PARAM_DEFAULTS = p_dict;
	
	eqn.set_params_to_default();
	eqn.init();


func call_fn(x):
	eqn.y.call_func(x);


func range_min_x():
	return slice_range.origin.x;

func range_min_y():
	return slice_range.origin.y;

func range_max_x():
	return slice_range.origin.x + slice_range.x.x;

func range_max_y():
	return slice_range.origin.y + slice_range.y.y;

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
	
	return slice_pts_list;


func make_draw_points(eqn_pts):
	while(slice_pts_list.size() > 0):
		slice_pts_list.remove(0);
	
	update_slice_y_offset();
	slice_pts_list = slice_range.xform(eqn_pts);
	
	dirty = false;

func get_slice_space_pt(pt):
	return slice_range.xform(pt);


func update_slice_y_offset():
	var prev_offset := 0.0;
	#TODO: create singleton "empty slice" instead of using null
	if (prev_slice != null):
		var prev_slice_end_y = prev_slice.slice_range.xform(prev_slice.right_connection)[Y];
		var prev_slice_origin = prev_slice.slice_range.origin.y;
		prev_offset = prev_slice_origin + prev_slice_end_y;
	
	if (eqn.PARITY == 1):
		var slice_mod = -(left_connection[Y] * slice_range.y.y);
		slice_range.origin.y = prev_offset + slice_mod;
	elif (eqn.PARITY == -1):
		var slice_mod = -(1-(left_connection[Y] * slice_range.y.y));
		slice_range.origin.y = prev_offset + slice_mod;
	
	print(slice_range.origin.y);
	
	if (next_slice != null):
		next_slice.dirty = true;


