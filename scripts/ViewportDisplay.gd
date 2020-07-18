#extends Panel
extends ViewportContainer

onready var T_graph = preload("res://scenes/graph.tscn");
onready var viewport = get_node("Viewport");
onready var placeholder = get_node("Placeholder");
onready var T_Marker = preload("res://scenes/EGG_Marker.tscn");
onready var N_Markers = get_parent().get_node("Markers");

var markers = Array();
var graph = null;

func _ready():
	get_tree().get_root().connect("size_changed", self, "screen_resize")
	
	graph = T_graph.instance();
	viewport.add_child(graph);
	graph.init();
	
	placeholder.visible = false;
	
	# Get the viewport and clear it.
	#viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")


func _process(delta):
	drag_markers();


func drag_markers():
	for m in markers:
		if (m.doDrag):
			var mouse_x = get_global_mouse_position()[0];
			
			var new_percent = get_graphx_from_globalx(mouse_x);
			#var new_x = get_markerx_from_graphx(new_percent);
			
			m.set_gcoords(Vector2(new_percent, graph.y(new_percent)));
		m.update_x(rect_size[0]);


func get_graphx_from_globalx(global_x):
	var graph_x = (global_x - get_global_rect().position[0]) / rect_size[0];
	graph_x = min(max(graph_x, 0), 1);
	return graph_x;

#func get_markerx_from_graphx(graph_x):
	#return (graph_x * rect_size[0]);


func _draw():
	self.draw_texture(viewport.get_texture(), Vector2(0,0));


func screen_resize():
	for m in markers:
		var m_per = m.get_percent();
		
		m.set_gcoords(Vector2(m_per, graph.y(m_per)));
		m.update_x(rect_size[0]);


func add_marker(after_i, gc, make_disabled):
	if (after_i < 0 || after_i > markers.size()):
		return;
	
	var new_marker = T_Marker.instance();
	markers.insert(after_i, new_marker);
	N_Markers.add_child(new_marker);
	new_marker.init(make_disabled);
	
	new_marker.set_gcoords(Vector2(gc[0], graph.y(gc[0])));

