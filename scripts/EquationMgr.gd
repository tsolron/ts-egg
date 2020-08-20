extends Node


var T_equation = preload("res://scenes/templates/T_equation.tscn");
var equation_templates := [  ];
var EType := {  };
var eqn_disp_name := {  };


func load_templates():
	equation_templates.clear();
	equation_templates = DB.get_equation_templates();
	for eqn_t in equation_templates:
		eqn_disp_name[eqn_t["ID"]] = eqn_t["DISPLAY_NAME"].to_lower().replace(" ","");
		EType[eqn_t["DISPLAY_NAME"].to_lower().replace(" ","")] = eqn_t["ID"];

