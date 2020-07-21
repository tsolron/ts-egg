extends Node

const bias = 8;
const display_name = "EaseInOutSine";

func y(x):
	return -(cos(PI * x) - 1) / 2;
