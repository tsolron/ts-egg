extends Panel

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
var draw_pts_list := [];
var dirty := true;
var graph_display_name := "";
var dbd_graph = null;


func init():
	EquationMgr.load_templates();
	load_graph_data();


func _process(_delta):
	update_graph_data();
	update();


func _draw():
	draw_graph_data();
	draw_slice_regions();


func load_graph_data():
	if (dbd_graph != null):
		return;
	
	dbd_graph = DB.get_graph_data(1);
	
	var slice_idx = 0;
	for dbd_slice in dbd_graph:
		graph_display_name = dbd_slice["GRAPH_NAME"];
		var y_start = 0;
		if (slice_idx > 0):
			y_start = slices[slice_idx-1].end_y();
		
		# use insert with slice_idx later
		add_slice(dbd_slice, y_start);
		slice_idx += 1;
	
	#add_slice_at(0, EquationMgr.EType["linear"], 1);
	#add_slice_at(1, EquationMgr.EType["easeinoutsine"], 1);


func update_graph_data():
	if (!dirty): return;
	
	draw_pts_list.clear();
	
	var prev_y_max = slices[0].end_y();
	
	for idx in range(slices.size()):
		var slice_rect = slices[idx].slice_range;
		#TODO: Make smart code for n_pts
		#var percent_of_graph_size = max((slice_rect.size[0] / max(1,graph_range.size[0])),(slice_rect.size[1] / max(1,graph_range.size[1])));
		#var n_pts = min(256, max(16, (slice.eqn.N_PTS_BIAS_MULTIPLIER * 10 * percent_of_graph_size)));
		var n_lines = 64;
		var slice_pts_list = slices[idx].get_draw_points(n_lines);
		draw_pts_list.push_back(slice_pts_list);
		
		#if (slices[idx].eqn.PARITY == -1):
		#	slices[idx].slice_range.origin.y = prev_y_max - slices[idx].slice_range.y.y;
		prev_y_max = slices[idx].slice_range.get_origin().y;
	
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
	
	var marker_x = 0;
	
	for slice_idx in range(draw_pts_list.size()):
		var draw_pts = draw_pts_list[slice_idx];
		
		if (doDrawGraph):
			for idx in range(draw_pts.size() - 1):
				var pt1 = draw_pts[idx] + axis_offset.get_origin();
				var pt2 = draw_pts[idx+1] + axis_offset.get_origin();
				draw_line(pt1, pt2, lineColor, lineWidth);
		
		#TODO: correct this
		if (doDrawMarker):
			marker_x = slices[slice_idx].slice_range.get_origin().x;
			#draw_line(
					#Vector2(marker_x + axis_offset.origin.x, 0),
					#Vector2(marker_x + axis_offset.origin.x, rect_size[Y]),
					#markerColor, lineWidth);
			pass;
		
		if (slice_idx+1 < draw_pts_list.size()):
			if (doDrawGraph):
				var pt1 = draw_pts[draw_pts.size()-1] + axis_offset.get_origin();
				var pt2 = draw_pts_list[slice_idx+1][0] + axis_offset.get_origin();
				draw_line(pt1, pt2, lineColor, lineWidth);
		elif (doDrawMarker):
			marker_x = slices[slice_idx].slice_range.origin.x + slices[slice_idx].slice_range.x.x;
			#draw_line(
					#Vector2(marker_x + axis_offset[X], 0),
					#Vector2(marker_x + axis_offset[X], rect_size[Y]),
					#markerColor, lineWidth);
			pass;


func draw_slice_regions():
	if (!doDrawSlice):
		return;
	if (dirty):
		update_graph_data();
	
	for slice_idx in range(draw_pts_list.size()):
		var s_range = Rect2();
		s_range.position = slices[slice_idx].slice_range.get_origin() + axis_offset.get_origin();
		s_range.size = slices[slice_idx].slice_range.get_scale();
		#slices[slice_idx].slice_range;
		#s_range.origin += axis_offset;
		#s_range.size[Y] *= slices[slice_idx].eqn.PARITY;
		draw_rect(s_range, sliceRegionColor, true);


func add_slice(dbd_slice, y_start):
	var slice = T_slice.instance();
	add_child(slice);
	
	slice.init(dbd_slice, y_start);
	if (slices.size() > 0):
		slice.prev_slice = slices.back();
		slice.prev_slice.next_slice = slice;
	slices.push_back(slice);


#TODO: implement
func insert_slice():
	#var offset = Vector2();
	#offset[X] = slices[n-1].slice_range.position[X] + slices[n-1].slice_range.size[X];
	#offset[Y] = slices[n-1].eqn_parity * slices[n-1].eqn.y(offset[X]);
	#slices[n].slice_range.position = offset;
	#TODO: Still need to automate size assignment
	#slice.slice_range.size[X] = 128;
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
