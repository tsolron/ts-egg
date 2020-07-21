extends Node
#class_name EQN_linear

const bias = 2;
const display_name = "Linear";
const eqn_display_template = "y = (%.2f * x) + %.2f";

var m = null;
var default_m = 1;
var b = null;
var default_b = 0;

func y(x):
	if (m == null):
		m = default_m;
	
	if (b == null):
		b = default_b;
	
	return (m * x) + b;


func get_eqn_display():
	return eqn_display_template % [m, b];
