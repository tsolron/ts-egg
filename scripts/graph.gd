extends Panel

onready var T_Marker = preload("res://scenes/EGG_Marker.tscn");
onready var N_Markers = $Markers;

var doDrawGraph = true;
var color = Color(1.0, 0.0, 0.0);
var markers = Array();



func _ready():
	add_marker(0, true);
	add_marker(1, false);


func _draw():
	if (doDrawGraph):
		drawGraph();
	pass;


func _process(delta):
	update();


func drawGraph():
	var gsize = rect_size;
	var goffset = Vector2(0.0, get_global_rect().size[1]);
	
	var nb_points = 32
	var points_graph = PoolVector2Array();
	
	for i in range(nb_points + 1):
		var x = float(i)/float(nb_points);
		var y = fn_ease_in_expo(x);
		
		points_graph.push_back(Vector2(x, -y));
	
	for idx_pt in range(nb_points):
		draw_line(points_graph[idx_pt]*gsize+goffset, points_graph[idx_pt + 1]*gsize+goffset, color)


func add_marker(after_i, make_disabled):
	if (after_i < 0 || after_i > markers.size()):
		return;
	
	var new_marker = T_Marker.instance();
	new_marker.graph = self;
	
	new_marker.init(make_disabled);
	
	markers.insert(after_i, new_marker);
	N_Markers.add_child(new_marker);


func get_coords_from_marker(marker):
	var coords = marker.rect_position;
	coords[0] += (marker.rect_size[0] / 2);
	coords[0] /= self.rect_size[0];
	
	coords[1] = fn_ease_in_expo(coords[0]);
	
	return coords;


func _on_DrawButton_pressed():
	doDrawGraph = !doDrawGraph;


func fn_ease_in_sine(x):
	return 1 - cos((x * PI) / 2);

func fn_ease_out_sine(x):
	return -(cos(PI * x) - 1) / 2;

func fn_ease_inout_sine(x):
	return -(cos(PI * x) - 1) / 2;

func fn_ease_in_expo(x):
	if (x == 0):
		return 0.0;
	return pow(2, 10 * x - 10);

func fn_ease_out_expo(x):
	if (x == 1):
		return 1;
	return 1 - pow(2, -10 * x);
