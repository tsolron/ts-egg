extends Node

const bias = 2;
const display_name = "Constant";
const eqn_display_template = "y = %.2f";

var b = null;
var default_b = 0;

func y(x):
	if (b == null):
		b = default_b;
	
	return b;

func get_eqn_display():
	return eqn_display_template % [b];
