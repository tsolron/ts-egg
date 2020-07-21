extends Panel

#onready var vpc = get_parent().get_parent();
onready var T_slice = preload("res://scenes/templates/T_slice.tscn");
#onready var EquationMgr = preload("res://scripts/EquationMgr.gd");

enum {X, Y}

var doDrawGraph = true;
var lineColor = Color(1.0, 0.0, 0.0, 1.0);
var markerColor = Color(0.0, 0.0, 1.0, 0.75);
var slices = [];
var graph_range = Rect2(0,0,0,0);
var axis_offset = Vector2(32,32);
var draw_pts_list = [];
var dirty = true;


func init():
	add_slice_at(0, EquationMgr.EType.LINEAR, 1);
	add_slice_at(1, EquationMgr.EType.EASEINOUTSINE, -1);


func _process(_delta):
	update_graph_data();
	update();


func _draw():
	draw_graph_data();


func update_graph_data():
	if (!dirty): return;
	
	draw_pts_list.clear();
	
	update_graph_bounds();
	
	for slice in slices:
		var slice_rect = slice.slice_range;
		var percent_of_graph_size = max((slice_rect.size[0] / max(1,graph_range.size[0])),(slice_rect.size[1] / max(1,graph_range.size[1])));
		var n_eqn_pts = min(256, max(16, (slice.eqn.bias * 10 * percent_of_graph_size)));
		var draw_pts = slice.get_draw_points(n_eqn_pts);
		draw_pts_list.push_back(draw_pts);
	
	dirty = false;


func update_graph_bounds():
	if (!dirty): return;
	
	var bounds = Rect2(0,0,0,0);
	for slice in slices:
		bounds.position[X] = min(slice.range_min_x(), bounds.position[X]);
		bounds.position[Y] = min(slice.range_min_y(), bounds.position[Y]);
		bounds.size[X] = max(slice.range_max_x(), bounds.position[X] + bounds.size[X]);
		bounds.size[Y] = max(slice.range_max_y(), bounds.position[Y] + bounds.size[Y]);
	graph_range = bounds;
	
	dirty = false;


func draw_graph_data():
	if (!doDrawGraph):
		return;
	if (dirty):
		update_graph_data();
	
	graph_range.position = Vector2(10,10);
	
	for slice_idx in range(draw_pts_list.size()):
		var draw_pts = draw_pts_list[slice_idx];
		
		for idx in range(draw_pts.size() - 1):
			var pt1 = draw_pts[idx] + axis_offset;
			var pt2 = draw_pts[idx+1] + axis_offset;
			draw_line(pt1, pt2, lineColor);
		
		var marker_x = slices[slice_idx].slice_range.position[X];
		draw_line(
				Vector2(marker_x + axis_offset[X], 0),
				Vector2(marker_x + axis_offset[X], rect_size[Y]),
				markerColor);
		
		if (slice_idx+1 < draw_pts_list.size()):
			var pt1 = draw_pts[draw_pts.size()-1] + axis_offset;
			var pt2 = draw_pts_list[slice_idx+1][0] + axis_offset;
			draw_line(pt1, pt2, lineColor);
		else:
			marker_x = slices[slice_idx].slice_range.position[X] + slices[slice_idx].slice_range.size[X];
			draw_line(
					Vector2(marker_x + axis_offset[X], 0),
					Vector2(marker_x + axis_offset[X], rect_size[Y]),
					markerColor);


func add_slice_at(n, eType, parity):
	var slice = T_slice.instance();
	add_child(slice);
	slice.init(self);
	slice.set_eqn(eType, parity);
	
	if (slices.empty()):
		slice.config_as_first();
		slices.push_back(slice);
		return;
	
	slices.insert(n, slice);
	if (n == 0):
		
		pass
	else:
		var offset = Vector2();
		offset[X] = slices[n-1].slice_range.position[X] + slices[n-1].slice_range.size[X];
		offset[Y] = slices[n-1].eqn_parity * slices[n-1].eqn.y(offset[X]);
		
		slices[n].slice_range.position = offset;
	
	#TODO: Still need to automate size assignment
	slice.slice_range.size[X] = 128;
	


func rescale_slices():
	
	pass;
