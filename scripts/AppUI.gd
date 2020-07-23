extends Panel


onready var vpc = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBox_Mid/ViewportContainer");
onready var left_buttons = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBox_Left");
onready var right_buttons = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBox_Right");


func _ready():
	#TODO: hard coded
	#<source_node>.connect(<signal_name>, <target_node>, <target_function_name>)
	var btg = left_buttons.get_node("btn_toggle_graph");
	btg.connect("btn_toggle", self, "btn_toggle_handler");
	
	var bts = left_buttons.get_node("btn_toggle_slice");
	bts.connect("btn_toggle", self, "btn_toggle_handler");
	
	var btm = left_buttons.get_node("btn_toggle_marker");
	btm.connect("btn_toggle", self, "btn_toggle_handler");
	
	#var bve = right_buttons.get_node("btn_var_edit");
	#bve.connect("btn_var_edit", self, "btn_var_edit_handler");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rect_size = OS.window_size;


func btn_toggle_handler(type, value):
	vpc.graph.hideGData(type, value);


func btn_var_edit_handler(slice_idx, var_name, value):
	
	pass;
