extends Node
#class_name EQN_linear

const bias = 2;
const display_name = "Linear";
const eqn_display_template = "y = (%.2f * x) + %.2f";
const eqn_command = "(m * x) + b";
const eqn_param_defaults = { "m": 1, "b": 0, };

var expression = Expression.new();
var eqn_params = eqn_param_defaults.duplicate();


func y(x):
	var error = expression.parse(eqn_command, ["x"] + eqn_params.keys());
	if (error != OK):
		print("Error: Expression unable to be parsed");
		return;
	else:
		return expression.execute([x] + eqn_params.values(), null, true);


func get_eqn_display():
	return eqn_display_template % eqn_params.values();

