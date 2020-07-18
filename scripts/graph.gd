extends Panel

onready var vpc = get_parent().get_parent();
var doDrawGraph = true;
var color = Color(1.0, 0.0, 0.0);


func init():
	vpc.add_marker(0, Vector2(0,0), true);
	vpc.add_marker(1, Vector2(0.5,0), false);
	vpc.add_marker(2, Vector2(1,0), true);


func _draw():
	if (doDrawGraph):
		drawGraph();


func _process(delta):
	update();


func drawGraph():
	var gsize = rect_size;
	var goffset = Vector2(0.0, 0.0);
	
	var nb_points = 64
	var points_graph = PoolVector2Array();
	
	for i in range(nb_points + 1):
		var x = float(i)/float(nb_points);
		var y = fn_ease_in_expo(x);
		
		points_graph.push_back(Vector2(x, y));
	
	for idx_pt in range(nb_points):
		draw_line(points_graph[idx_pt]*gsize+goffset, points_graph[idx_pt + 1]*gsize+goffset, color)


func y(x):
	return fn_ease_in_expo(x);


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
