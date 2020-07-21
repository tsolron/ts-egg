extends Node

#class_name EquationMgr

var EQN_constant = preload("res://scenes/templates/EQN_constant.tscn");
var EQN_linear = preload("res://scenes/templates/EQN_linear.tscn");
var EQN_easeinoutsine = preload("res://scenes/templates/EQN_easeinoutsine.tscn");

enum EType {
	CONSTANT,
	LINEAR,
	EASEINOUTSINE
}

var equations = [
	EQN_constant,
	EQN_linear,
	EQN_easeinoutsine
];


