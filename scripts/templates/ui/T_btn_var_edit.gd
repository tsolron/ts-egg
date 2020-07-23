extends Button

signal btn_var_edit(slice_idx, var_name, value);

onready var eqn_edit = $eqn_edit;
onready var eqn_left = $eqn_left;
var origin_slice_idx = 0;
var origin_var_name = "";
var origin_var_value = 0.0;


func _ready():
	pass


func init(idx, vname, value):
	origin_slice_idx = idx;
	origin_var_name = vname;
	origin_var_value = value;


func _on_pressed():
	self.text = "";
	eqn_left.visible = true;
	eqn_edit.visible = true;
	#eqn_edit.text = ?
	eqn_edit.editable = true;


func _on_eqn_edit_text_entered(new_text):
	if is_valid_number(new_text):
		emit_signal("btn_var_edit", origin_slice_idx, origin_var_name, new_text);
		self.text = "";
		eqn_left.visible = false;
		eqn_edit.visible = false;
		eqn_edit.editable = false;
	else:
		#TODO: Notification of invalid number? Reset to previous value?
		pass;

#TODO: implement
func is_valid_number(test_text):
	return true;
