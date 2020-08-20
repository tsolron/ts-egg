extends Button

signal btn_toggle(type, value);

export var targetDisplayName: String = "Graph";
export var defaultTurnOff: bool = false;
var isToggleOff: bool = false;

func _ready():
	isToggleOff = defaultTurnOff;

func _on_btn_toggled(button_pressed):
	if (button_pressed):
		isToggleOff = false;
		emit_signal("btn_toggle", targetDisplayName.to_lower(), true);
		
	else:
		isToggleOff = true;
		emit_signal("btn_toggle", targetDisplayName.to_lower(), false);
