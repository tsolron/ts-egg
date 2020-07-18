extends ToolButton

var graph = null;
var doDrag = false;
var label_text_template = "x: %.3f\r\ny: %.3f";

func init(make_disabled):
	if (make_disabled):
		self.disabled = true;
		self.button_mask = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_text();
	
	var newx = rect_position[0];
	if (doDrag):
		var x_min = graph.get_global_rect().position[0];
		var x_max = graph.rect_size[0] + x_min;
		newx = get_global_mouse_position()[0]
		newx = max(x_min, min(x_max, newx)) - x_min - rect_size[0]/2;
	set_position(Vector2(newx, 0));


func update_text():
	var coords = graph.get_coords_from_marker(self);
	$Label.text = label_text_template % [coords[0], coords[1]];

func _on_EGG_Marker_button_down():
	doDrag = true;


func _on_EGG_Marker_button_up():
	doDrag = false;
