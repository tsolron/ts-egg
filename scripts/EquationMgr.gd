extends Node

#class_name EquationMgr

var T_equation = preload("res://scenes/templates/T_equation.tscn");

enum EType {
	CONSTANT,
	LINEAR,
	EASEINOUTSINE
}


var eqn_nptsbias = [
	1.0,
	1.0,
	1.0
];

var eqn_disp_name = [
	"Constant",
	"Linear",
	"Ease In Out Sine"
]

var eqn_disp_template = [
	"y = %.2f",
	"y = (%.2f * x) + %.2f",
	"y = -(cos(PI * x) - 1) / 2"
];

var eqn_y_equals = [
	"b",
	"(m * x) + b",
	"-(cos(PI * x) - 1) / 2"
];

var eqn_param_defaults = [
	{ "m": 0, "b": 0, },
	{ "m": 1, "b": 0, },
	{  }
];


func configure(eqn, type):
	eqn.N_PTS_BIAS_MULTIPLIER = eqn_nptsbias[type];
	eqn.DISPLAY_NAME = eqn_disp_name[type];
	eqn.EQN_DISPLAY_TEMPLATE = eqn_disp_template[type];
	eqn.EQN_Y_EQUALS = eqn_y_equals[type];
	eqn.EQN_PARAM_DEFAULTS = eqn_param_defaults[type];
	eqn.set_params_to_default();
