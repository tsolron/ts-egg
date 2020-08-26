extends Panel
class_name Graph


#onready var vpc = get_parent().get_parent();
onready var T_slice = preload("res://scenes/templates/T_slice.tscn");
#onready var EquationMgr = preload("res://scripts/EquationMgr.gd");

enum {X, Y}

var doDrawGraph := true;
var doDrawSlice := false;
var doDrawMarker := true;
var lineColor := Color(1.0, 0.0, 0.0, 1.0);
var markerColor := Color(0.0, 0.0, 1.0, 0.75);
var sliceRegionColor := Color(1.0, 1.0, 0.0, 0.25);
var lineWidth := 2.0;
var slices := [];
var graph_range := Transform2D(Vector2(0,0), Vector2(0,0), Vector2(0,0));
var axis_offset := Transform2D(Vector2(1,0), Vector2(0,1), Vector2(32,32));
var draw_pts_list := PoolVector2Array();
var dirty := true;
var graph_display_name := "";
var dbd_graph := [];


func init():
	#self.rect_size[X] /= 2.0;
	EquationMgr.load_templates();
	load_graph_data();


func _process(_delta):
	update_graph_data();
	update();


func _draw():
	draw_graph_data();
	draw_slice_regions();
	draw_slice_borders();


func load_graph_data():
	if (dbd_graph.size() > 0):
		return;
	
	dbd_graph = DB.get_graph_data(1);
	
	#var slice_idx = 0;
	for dbd_slice in dbd_graph:
		graph_display_name = dbd_slice["GRAPH_NAME"];
		
		#TODO: use insert with slice_idx later
		add_slice(dbd_slice);
		#slice_idx += 1;


func update_graph_data():
	if (!dirty): return;
	
	#draw_pts_list.clear();
	#TODO: Ensure this works properly
	while (draw_pts_list.size() > 0):
		draw_pts_list.remove(0);
	
	for idx in range(slices.size()):
		#var slice_rect = slices[idx].slice_range;
		#TODO: Make smart code for n_pts
		#var percent_of_graph_size = max((slice_rect.size[0] / max(1,graph_range.size[0])),(slice_rect.size[1] / max(1,graph_range.size[1])));
		#var n_pts = min(256, max(16, (slice.eqn.N_PTS_BIAS_MULTIPLIER * 10 * percent_of_graph_size)));
		var n_lines = 64;
		var slice_pts_list = slices[idx].get_draw_points(n_lines);
		draw_pts_list.append_array(slice_pts_list);
	
	draw_pts_list = axis_offset.xform(draw_pts_list);
	
	update_graph_bounds();
	
	dirty = false;


func update_graph_bounds():
	if (!dirty): return;
	
	for slice in slices:
		graph_range.origin.x = min(slice.range_min_x(), graph_range.origin.x);
		graph_range.origin.y = min(slice.range_min_y(), graph_range.origin.y);
		graph_range.x.x = max(slice.range_max_x(), graph_range.x.x);
		graph_range.y.y = max(slice.range_max_y(), graph_range.y.y);


func draw_graph_data():
	if (dirty):
		update_graph_data();
	
	if (doDrawGraph):
		draw_polyline(draw_pts_list, lineColor, lineWidth);


func draw_slice_regions():
	if (!doDrawSlice):
		return;
	if (dirty):
		update_graph_data();
	
	for slice_idx in range(slices.size()):
		draw_slice(slices[slice_idx]);


func draw_slice(slice):
	var s_range = Rect2();
	s_range.position = axis_offset.xform(slice.slice_range.get_origin());
	s_range.size = slice.slice_range.get_scale();
	draw_rect(s_range, sliceRegionColor, true);


#TODO: Improve y-coordinate in function ("works" but kind of "hacky")
func draw_slice_borders():
	if (!doDrawMarker):
		return;
	if (dirty):
		update_graph_data();
	
	var border_pts := PoolVector2Array();
	for slice_idx in range(slices.size()):
		var temp = slices[slice_idx].slice_range.origin;
		temp[Y] = -graph_range.y.y;
		border_pts.push_back(temp);
		temp[Y] = graph_range.y.y * 2;
		border_pts.push_back(temp);
	
	var end_border_pt1 = slices.back().slice_range.origin;
	end_border_pt1[X] += slices.back().slice_range.x.x;
	end_border_pt1[Y] = -graph_range.y.y;
	var end_border_pt2 = end_border_pt1;
	end_border_pt2[Y] = graph_range.y.y * 2;
	
	border_pts.push_back(end_border_pt1);
	border_pts.push_back(end_border_pt2);
	
	border_pts = axis_offset.xform(border_pts);
	
	draw_multiline(border_pts, markerColor);


func add_slice(dbd_slice):
	var slice = T_slice.instance();
	add_child(slice);
	
	if (slices.size() > 0):
		slice.prev_slice = slices.back();
		slice.prev_slice.next_slice = slice;
	
	slice.init(dbd_slice);
	
	slices.push_back(slice);


#TODO: implement
func insert_slice():
	pass;


#TODO
func rescale_slices():
	pass;


func hideGData(type, value):
	match(type):
		"graph":
			doDrawGraph = value;
		"slice":
			doDrawSlice = value;
		"marker":
			doDrawMarker = value;
