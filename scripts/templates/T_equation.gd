extends Node
class_name Equation


# for example, a sine function with a large amplitude may need
#   more points to accurately depict than a linear function
var N_PTS_BIAS_MULTIPLIER := 1.0;
var DISPLAY_TEMPLATE := "";
var DISPLAY_NAME := "";
var EQN_Y_EQUALS := "";
var PARITY := 1.0;
var IS_NORMALIZED := true;
var TRUNCATE_RANGE := Vector2();
var EQN_PARAM_DEFAULTS := {  };


var expression := Expression.new();
var eqn_params := {  };
var dirty := true;
var pts_list := PoolVector2Array();
var pts_n := 2;
var n_pts_list := PoolVector2Array();
var equation_range := Transform2D();


enum {X=0, WIDTH=1, Y=1}


func init(dbd_slice):
	N_PTS_BIAS_MULTIPLIER = dbd_slice["N_PTS_BIAS_MULTIPLIER"];
	DISPLAY_TEMPLATE = dbd_slice["DISPLAY_TEMPLATE"];
	DISPLAY_NAME = dbd_slice["DISPLAY_NAME"];
	EQN_Y_EQUALS = dbd_slice["Y_EQUALS"];
	
	PARITY = dbd_slice["PARITY"];
	IS_NORMALIZED = dbd_slice["IS_NORMALIZED"];
	TRUNCATE_RANGE = Vector2(dbd_slice["TRUNCATE_RANGE_X"],dbd_slice["TRUNCATE_RANGE_WIDTH"]);
	
	var p_names = dbd_slice["PARAM_NAMES"].split(",", false);
	var p_values = dbd_slice["PARAM_VALUES"].split(",", false);
	var p_dict = {  };
	for i in range(p_names.size()):
		p_dict[p_names[i]] = float(p_values[i]);
	EQN_PARAM_DEFAULTS = p_dict;
	
	set_params_to_default();
	
	equation_range.origin.x = TRUNCATE_RANGE[X];
	equation_range.x.x = TRUNCATE_RANGE[WIDTH];
	
	# Uses the default (2) points, used for creating default slice_size
	make_n_pts();


func y(x: float) -> float:
	var error = expression.parse(EQN_Y_EQUALS, ["x"] + eqn_params.keys());
	if (error != OK):
		print("Error: Expression unable to be parsed");
		return 0.0;
	else:
		return expression.execute([x] + eqn_params.values(), null, true) * PARITY;


func get_n_pts(n_pts: int) -> PoolVector2Array:
	if (dirty || (n_pts != pts_n)):
		pts_n = n_pts;
		make_n_pts();
	
	return n_pts_list;


func make_n_pts():
	#TODO: Ensure this works properly
	while (pts_list.size() > 0):
		pts_list.remove(0);
	while (n_pts_list.size() > 0):
		n_pts_list.remove(0);
	
	var y_min := 0.0;
	var y_max := 0.0;
	
	var x := 0.0;
	var y := 0.0;
	
	var x_per_i := equation_range.x.x / pts_n;
	
	for i in range(pts_n):
		
		# x ∈ [0, 1]
		# x ∈ [truncate range]
		x = float(i) * x_per_i + equation_range.origin.x;
		
		y = y(x);
		
		if (i == 0):
			y_min = y;
			y_max = y;
		
		y_min = min(y_min, y);
		y_max = max(y_max, y);
		
		pts_list.append(Vector2(x,y));
	
	equation_range.origin.y = y_min;
	equation_range.y.y = abs(y_max - y_min);
	
	n_pts_list = H.transform_reverse(equation_range, pts_list);
	
	dirty = false;


func get_eqn_display() -> String:
	return DISPLAY_TEMPLATE % eqn_params.values();


func set_params_to_default():
	eqn_params = EQN_PARAM_DEFAULTS.duplicate();
