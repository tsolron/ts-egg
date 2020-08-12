extends Node

#class_name T_slice

var slice_range = Rect2();
var eqn = null;
var draw_pts = [];
var draw_n = 8;
var dirty = true;

enum {X, Y}


func init(x_start, x_end, y_start):
	slice_range.position[X] = x_start;
	slice_range.position[Y] = y_start;
	slice_range.size[X] = x_end - x_start;
	slice_range.size[Y] = slice_range.size[X];


func set_eqn(dbd_slice):
	eqn = EquationMgr.T_equation.instance();
	
	eqn.DISPLAY_NAME = dbd_slice["DISPLAY_NAME"];
	eqn.EQN_Y_EQUALS = dbd_slice["Y_EQUALS"];
	eqn.PARITY = dbd_slice["PARITY"];
	
	var p_names = dbd_slice["PARAM_NAMES"].split(",", false);
	var p_values = dbd_slice["PARAM_VALUES"].split(",", false);
	
	var p_dict = {  };
	for i in range(p_names.size()):
		p_dict[p_names[i]] = float(p_values[i]);
	
	eqn.EQN_PARAM_DEFAULTS = p_dict.duplicate();
	
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


func get_draw_points(n_pts):
	if (!dirty) && (n_pts == draw_n):
		return draw_pts;
	
	draw_n = n_pts;
	make_draw_points();
	return draw_pts;


func make_draw_points():
	draw_pts.clear();
	
	var y_min = eqn.PARITY * eqn.y(0);
	var y_max = y_min;
	
	for i in range(draw_n + 1):
		var x = (i/draw_n);# * slice_range.size[X];
		var y = eqn.y(x);
		
		x *= slice_range.size[X];
		x += slice_range.position[X];
		
		y_min = min(y_min, y);
		y_max = max(y_max, y);
		
		y *= slice_range.size[X];
		y += slice_range.position[Y];
		
		draw_pts.push_back(Vector2(x, y));
	
	y_min *= slice_range.size[X];
	y_min += slice_range.position[Y];
	y_max *= slice_range.size[X];
	y_max += slice_range.position[Y];
	
	slice_range.size[Y] = abs(y_max - y_min);
	
	dirty = false;
