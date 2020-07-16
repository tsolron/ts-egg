extends Panel

var doDrawGraph = false;
var color = Color(1.0, 0.0, 0.0);
var goffset = Vector2(0.0, 256);
var gsize = Vector2(128*4, -256);
#var width = 128*5;
#var height = -256;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if (doDrawGraph):
		drawGraph();
	pass;

func _process(delta):
	update();


func drawGraph():
	var nb_points = 32
	var points_graph = PoolVector2Array();
	
	for i in range(nb_points + 1):
		var pt1 = float(i)/float(nb_points);
		var pt2 = -(cos(PI * pt1) - 1) / 2;
		
		points_graph.push_back(Vector2(pt1, pt2));
	
	for index_point in range(nb_points):
		draw_line(points_graph[index_point]*gsize+goffset, points_graph[index_point + 1]*gsize+goffset, color)
	
	#return -(cos(PI * x) - 1) / 2;;

func _on_DrawButton_pressed():
	doDrawGraph = !doDrawGraph;
