extends Node

#class_name T_slice

var graph = null;

var slice_range = Rect2();
var eqn = null;
var eqn_parity = 1;
var draw_pts = [];
var draw_n = 8;
var dirty = true;

enum {X, Y}


func init(g):
	graph = g;


func set_eqn(type, parity):
	eqn = EquationMgr.equations[type].instance();
	eqn_parity = parity;


func call_fn(x):
	eqn.y.call_func(x);


func config_as_first():
	#TODO: use graph.rect_size
	slice_range.position = Vector2(0,0);
	slice_range.size = Vector2(64,64);
	update_range();


#TODO: Is this function even needed?
func update_range():
	if (dirty):
		make_draw_points();
	
	# x is fixed from graph
	# so only update y
	var y_min = draw_pts[0][Y];
	var y_max = draw_pts[0][Y];
	for i in range(draw_pts.size()):
		y_min = min(y_min, draw_pts[i][Y]);
		y_max = max(y_max, draw_pts[i][Y]);
	#slice_range.position[Y] = y_min;
	slice_range.size[Y] = abs(y_max - y_min);


func range_min_x():
	return slice_range.position[X];

func range_min_y():
	return slice_range.position[Y];

func range_max_x():
	return slice_range.position[X] + slice_range.size[X];

func range_max_y():
	return slice_range.position[Y] + slice_range.size[Y];


func get_draw_points(n_pts):
	if (!dirty) && (n_pts == draw_n):
		return draw_pts;
	
	draw_n = n_pts;
	make_draw_points();
	return draw_pts;


func make_draw_points():
	draw_pts.clear();
	
	for i in range(draw_n + 1):
		var x = (i/draw_n);# * slice_range.size[X];
		var y = eqn_parity * eqn.y(x);
		
		x *= slice_range.size[X];
		x += slice_range.position[X];
		
		y *= slice_range.size[X];
		y += slice_range.position[Y];
		
		draw_pts.push_back(Vector2(x, y));
	
	dirty = false;
