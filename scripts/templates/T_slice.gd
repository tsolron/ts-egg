extends Node

#class_name T_slice

#var slice_range := Rect2();
var slice_range := Transform2D();
var eqn = null;
var slice_pts_list := [];
var draw_n := 8;
var dirty := true;
var prev_slice = null;
var next_slice = null;

enum {X, Y}


func init(dbd_slice, y_start):
	#slice_range.position[X] = dbd_slice["SLICE_X"];
	#slice_range.position[Y] = y_start;
	#slice_range.size[X] = dbd_slice["SLICE_WIDTH"];
	#slice_range.size[Y] = slice_range.size[X];
	slice_range.origin.x = dbd_slice["SLICE_X"];
	slice_range.origin.y = y_start;
	slice_range.x.x = dbd_slice["SLICE_WIDTH"];
	slice_range.y.y = slice_range.x.x;
	
	set_eqn(dbd_slice);


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

func end_y():
	var t1 = eqn.n_pts_list.back();
	var t2 = get_slice_space_pt(t1);
	return t2[Y];

func range_min_x():
	#return slice_range.position[X];
	return slice_range.origin.x;

func range_min_y():
	#return slice_range.position[Y];
	return slice_range.origin.y;

func range_max_x():
	#return slice_range.position[X] + slice_range.size[X];
	return slice_range.origin.x + slice_range.x.x;

func range_max_y():
	#return slice_range.position[Y] + slice_range.size[Y];
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


# TODO: Move most of this to T_equaution
# then eqn is only "dirty" if draw_n or the equation changes
# and slice just fits slice_pts_list to the slice size
func make_draw_points(eqn_pts):
	slice_pts_list.clear();
	
	if (eqn.PARITY == -1):
		slice_range.origin.y = prev_slice.end_y() - slice_range.y.y;
		#TODO: create singleton "empty slice" instead of using null
		if (next_slice != null):
			next_slice.dirty = true;
	
	for pt in eqn_pts:
		slice_pts_list.push_back(get_slice_space_pt(pt));
	
	dirty = false;

func get_slice_space_pt(pt):
	var t1 = (pt.get_origin() * pt.get_scale());
	var t2 = t1 * slice_range.get_scale();
	var t3 = t2 + slice_range.get_origin();
	
	return t3;
