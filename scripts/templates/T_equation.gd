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
var TRUNCATE_RANGE := Vector2();


var expression := Expression.new();
var eqn_params := {  };
var dirty := true;
var pts_list := [];
var pts_n := 1;
var n_pts_list := [];
var equation_range := Transform2D();
#var eqn_size := Vector2.ZERO;
#var eqn_size := Transform2D();
#var first_point := 0.0;
#var last_point := 0.0;


enum {X, WIDTH}


func init():
	equation_range.origin.x = TRUNCATE_RANGE[X];
	equation_range.x.x = TRUNCATE_RANGE[WIDTH];
	get_n_pts(8.0);


func y(x):
	var error = expression.parse(EQN_Y_EQUALS, ["x"] + eqn_params.keys());
	if (error != OK):
		print("Error: Expression unable to be parsed");
		return;
	else:
		return expression.execute([x] + eqn_params.values(), null, true) * PARITY;


func get_n_pts(n_pts):
	if (!dirty && (n_pts == pts_n)):
		return n_pts_list;
	
	pts_n = n_pts;
	pts_list.clear();
	n_pts_list.clear();
	
	var y_min := 0.0;
	var y_max := 0.0;
	
	var x := 0.0;
	var y := 0.0;
	
	var x_per_i := equation_range.x.x / pts_n;
	
	for i in range(pts_n + 1):
		
		# x ∈ [0, 1]
		# x ∈ [truncate range]
		x = float(i) * x_per_i + equation_range.origin.x;
		
		y = y(x);
		
		if (i == 0):
			y_min = y;
			y_max = y;
		
		y_min = min(y_min, y);
		y_max = max(y_max, y);
		
		pts_list.push_back(Transform2D(Vector2(1,0),Vector2(0,1), Vector2(x,y)));
	
	equation_range.origin.y = y_min;
	equation_range.y.y = abs(y_max - y_min);
	
	for pt in pts_list:
		var t = pt;
		t.origin -= equation_range.get_origin();
		if (equation_range.x.x != 0):
			t.x.x /= equation_range.x.x;
		if (equation_range.y.y != 0):
			t.y.y /= equation_range.y.y;
		
		if (t.origin.y > 200):
			var abc = 123;
		
		n_pts_list.push_back(t);
	
	dirty = false;
	
	return n_pts_list;


func get_eqn_display():
	return DISPLAY_TEMPLATE % eqn_params.values();


func set_params_to_default():
	eqn_params = EQN_PARAM_DEFAULTS.duplicate();
