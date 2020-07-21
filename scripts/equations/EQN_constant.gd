extends Node

const bias = 2;
const display_name = "Constant";

var b = null;
var default_b = 0;

func y(x):
	if (b == null):
		b = default_b;
	
	return b;
