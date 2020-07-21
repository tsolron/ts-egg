extends Node

const bias = 8;
const display_name = "EaseInOutSine";
const eqn_display_template = "y = -(cos(PI * x) - 1) / 2";

func y(x):
	return -(cos(PI * x) - 1) / 2;

func get_eqn_display():
	return eqn_display_template;
