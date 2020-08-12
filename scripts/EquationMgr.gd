extends Node
#class_name EquationMgr


var T_equation = preload("res://scenes/templates/T_equation.tscn");
var equation_templates = null;
var EType = {  };
var eqn_disp_name = {  };


func load_templates():
	if (equation_templates != null):
		return;
	
	equation_templates = DB.get_equation_templates();
	for eqn_t in equation_templates:
		eqn_disp_name[eqn_t["ID"]] = eqn_t["DISPLAY_NAME"].to_lower().replace(" ","");
		EType[eqn_t["DISPLAY_NAME"].to_lower().replace(" ","")] = eqn_t["ID"];


func configure(eqn, type):
	for eqn_t in equation_templates:
		if (eqn_t["ID"] != type):
			continue;
		
		eqn.DISPLAY_NAME = eqn_t["DISPLAY_NAME"];
		eqn.EQN_Y_EQUALS = eqn_t["Y_EQUALS"];
		
		var p_names = eqn_t["PARAM_NAMES"].split(",", false);
		var p_values = eqn_t["PARAM_VALUES"].split(",", false);
		
		var p_dict = {  };
		for i in range(p_names.size()):
			p_dict[p_names[i]] = float(p_values[i]);
		
		eqn.EQN_PARAM_DEFAULTS = p_dict.duplicate();
	
	eqn.set_params_to_default();
