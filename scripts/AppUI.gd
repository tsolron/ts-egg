extends Panel


onready var vpc = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBox_Mid/ViewportContainer");
onready var left_buttons = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBox_Left");
onready var right_buttons = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBox_Right");


func _ready():
	#TODO: hard coded
	
	var bctg = left_buttons.get_node("btnchk_toggle_graph");
	bctg.connect("btn_toggle", self, "btn_toggle_handler");
	
	var bcts = left_buttons.get_node("btnchk_toggle_slice");
	bcts.connect("btn_toggle", self, "btn_toggle_handler");
	
	var bctm = left_buttons.get_node("btnchk_toggle_marker");
	bctm.connect("btn_toggle", self, "btn_toggle_handler");
	
	#var bve = right_buttons.get_node("btn_var_edit");
	#bve.connect("btn_var_edit", self, "btn_var_edit_handler");


func _input(_event):
	if (Input.is_action_pressed("exit")):
		shutdown();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rect_size = get_rect2_max(OS.window_size, rect_min_size);
	OS.window_size = rect_size;


func btn_toggle_handler(type, value):
	vpc.graph.hideGData(type, value);


#TODO: Is this used anywhere? / connected to a signal?
#func btn_var_edit_handler(slice_idx, var_name, value):
#	pass;


func get_rect2_min(u, v):
	var temp = u;
	temp[0] = min(temp[0], v[0]);
	temp[1] = min(temp[1], v[1]);
	return temp;

func get_rect2_max(u, v):
	var temp = u;
	temp[0] = max(temp[0], v[0]);
	temp[1] = max(temp[1], v[1]);
	return temp;

func shutdown():
	get_tree().quit();
