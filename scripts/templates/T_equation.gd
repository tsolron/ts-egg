extends Node
#class_name EQN_linear


# for example, a sine function with a large amplitude may need
#   more points to accurately depict than a linear function
var N_PTS_BIAS_MULTIPLIER := 1.0;
var DISPLAY_TEMPLATE := "";
var DISPLAY_NAME := "";
var EQN_Y_EQUALS := "";
var EQN_PARAM_DEFAULTS := {  };
var PARITY := 1.0;
var IS_NORMALIZED := true;
var TRUNCATE_RANGE := Vector2.ZERO;


var expression := Expression.new();
var eqn_params := {  };
var dirty := true;
var n_pts_list := [];
var n_pts_n := 1;
var eqn_size := Vector2.ZERO;


enum {X, Y}


func y(x):
	var error = expression.parse(EQN_Y_EQUALS, ["x"] + eqn_params.keys());
	if (error != OK):
		print("Error: Expression unable to be parsed");
		return;
	else:
		return expression.execute([x] + eqn_params.values(), null, true) * PARITY;


func get_n_pts(n_pts):
	if (!dirty && (n_pts == n_pts_n)):
		return n_pts_list;
	
	n_pts_n = n_pts;
	n_pts_list.clear();
	
	var x_min := TRUNCATE_RANGE[X];
	var x_max := TRUNCATE_RANGE[X] + TRUNCATE_RANGE[1];
	var y_min := 0.0;
	var y_max := 0.0;
	
	var x := 0.0;
	var y := 0.0;
	
	var x_per_i = TRUNCATE_RANGE[1] / n_pts_n;
	
	for i in range(n_pts_n + 1):
		
		# x ∈ [0, 1]
		if (IS_NORMALIZED):
			x = (i/n_pts_n) * x_per_i + TRUNCATE_RANGE[X];
		# x ∈ [truncate range]
		else:
			x = (i/n_pts_n);
		
		y = y(x);
		
		if (i == 0):
			y_min = y;
			y_max = y;
		
		y_min = min(y_min, y);
		y_max = max(y_max, y);
		
		var t = Transform2D()
		
		n_pts_list.push_back(Vector2(x, y));
	
	eqn_size[X] = TRUNCATE_RANGE[1];
	eqn_size[Y] = abs(y_max - y_min);
	
	dirty = false;


func get_eqn_display():
	return DISPLAY_TEMPLATE % eqn_params.values();


func set_params_to_default():
	eqn_params = EQN_PARAM_DEFAULTS.duplicate();
