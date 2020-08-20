extends ToolButton

onready var T_style_disabled = preload("res://themes/sbflat_disabled.tres");
onready var T_style_editable = preload("res://themes/sbflat_editable.tres");

onready var l_edit := $LineEdit;
var label_text_template := "x: %.3f\r\ny: %.3f";



var marker_num := 0;
var doDrag := false;
var g_coords := Vector2(0,0);


func init(make_disabled: bool, n: int):
	marker_num = n;
	
	if (make_disabled):
		self.disabled = true;
		self.button_mask = 0;
		self.mouse_filter = Control.MOUSE_FILTER_IGNORE;
		$LineEdit.editable = false;
		#add_stylebox_override("normal", T_style_disabled)
		#set("custom_styles/normal", T_style_disabled);
	#else:
		#set("custom_styles/normal", T_style_editable);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_text();


func update_text():
	$Label.text = label_text_template % [g_coords[0], g_coords[1]];

func _on_EGG_Marker_button_down():
	doDrag = true;


func _on_EGG_Marker_button_up():
	doDrag = false;


func get_x() -> float:
	return rect_position[0];


func set_gcoords(gc: Vector2):
	g_coords = gc;
	
func update_x(scale_x: float):
	set_position(Vector2((g_coords[0] * scale_x) - rect_size[0]/2, 0));

func get_percent() -> float:
	return g_coords[0];
