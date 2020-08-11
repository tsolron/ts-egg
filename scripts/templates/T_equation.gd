extends Node
#class_name EQN_linear


# for example, a sine function with a large amplitude may need
#   more points to accurately depict than a linear function
export var N_PTS_BIAS_MULTIPLIER = 1.0;
export var DISPLAY_NAME = "Linear";
export var EQN_DISPLAY_TEMPLATE = "y = (%.2f * x) + %.2f";
export var EQN_Y_EQUALS = "(m * x) + b";
export var EQN_PARAM_DEFAULTS = { "m": 1, "b": 0, };

var expression = Expression.new();
var eqn_params = null;


func y(x):
	var error = expression.parse(EQN_Y_EQUALS, ["x"] + eqn_params.keys());
	if (error != OK):
		print("Error: Expression unable to be parsed");
		return;
	else:
		return expression.execute([x] + eqn_params.values(), null, true);


func get_eqn_display():
	return EQN_DISPLAY_TEMPLATE % eqn_params.values();


func set_params_to_default():
	eqn_params = EQN_PARAM_DEFAULTS.duplicate();
