extends Node
class_name Slice


var slice_range := Transform2D();
var eqn: Equation = null;
var slice_pts_list := PoolVector2Array();
var draw_n := 8;
var dirty := true;
var prev_slice: Slice  = null;
var next_slice: Slice = null;
var left_connection := Vector2(0.0, 0.0);
var right_connection := Vector2(0.0, 1.0);

enum {X, Y}


func init(dbd_slice: Dictionary):
	slice_range.origin.x = dbd_slice["SLICE_X"];
	slice_range.origin.y = 0.0;
	slice_range.x.x = dbd_slice["SLICE_WIDTH"];
	slice_range.y.y = slice_range.x.x;
	
	set_eqn(dbd_slice);
	
	#TODO: Will need to update these on eqn updates
	#      Specifically equation_range and eqn_params
	left_connection = eqn.n_pts_list[0];
	right_connection = eqn.n_pts_list[eqn.n_pts_list.size()-1];
	
	update_slice_y_offset();


func set_eqn(dbd_slice: Dictionary):
	eqn = EquationMgr.T_equation.instance();
	eqn.init(dbd_slice);
	add_child(eqn);


func call_fn(x):
	eqn.y.call_func(x);


func range_min_x() -> float:
	return slice_range.origin.x;

func range_min_y() -> float:
	return slice_range.origin.y;

func range_max_x() -> float:
	return slice_range.origin.x + slice_range.x.x;

func range_max_y() -> float:
	return slice_range.origin.y + slice_range.y.y;

func get_marker_min_coords():
	#TODO
	pass;

func get_marker_max_coords():
	#TODO
	pass;


# includes slice location/size
func get_draw_points(n_pts: int) -> PoolVector2Array:
	if ((n_pts != draw_n) || (dirty) || (eqn.dirty)):
		draw_n = n_pts;
		make_draw_points(eqn.get_n_pts(n_pts));
	
	return slice_pts_list;


func make_draw_points(eqn_pts: PoolVector2Array):
	while(slice_pts_list.size() > 0):
		slice_pts_list.remove(0);
	
	update_slice_y_offset();
	slice_pts_list = slice_range.xform(eqn_pts);
	
	dirty = false;

func get_slice_space_pt(pt: Vector2) -> Vector2:
	return slice_range.xform(pt);


func update_slice_y_offset():
	var prev_offset := 0.0;
	
	#TODO: create singleton "empty slice" instead of using null
	if (prev_slice != null):
		prev_offset = prev_slice.slice_range.xform(prev_slice.right_connection)[Y];
	
	var slice_mod = (left_connection[Y] * slice_range.y.y);
	slice_range.origin.y = prev_offset - slice_mod;
	
	if (next_slice != null):
		next_slice.dirty = true;

