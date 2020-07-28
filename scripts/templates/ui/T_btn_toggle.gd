extends Button

signal btn_toggle(type, value);

export var whenEnabledAction = "Hide";
export var whenDisabledAction = "Show";
export var targetDisplayName = "Graph";
export var defaultTurnOff = false;
var label_template = "%s %s";
var isToggleOff;

func _ready():
	isToggleOff = defaultTurnOff;
	#if (isToggleOff):
	#	self.text = label_template % [whenDisabledAction, targetDisplayName];
	#else:
	#	self.text = label_template % [whenEnabledAction, targetDisplayName];

func _on_btn_toggled(button_pressed):
	if (button_pressed):
		isToggleOff = false;
		#self.text = label_template % [whenEnabledAction, targetDisplayName];
		emit_signal("btn_toggle", targetDisplayName.to_lower(), true);
		
	else:
		isToggleOff = true;
		#self.text = label_template % [whenDisabledAction, targetDisplayName];
		emit_signal("btn_toggle", targetDisplayName.to_lower(), false);
