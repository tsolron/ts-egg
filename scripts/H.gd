extends Node

# don't reference AppUI, use signals?

#marker management here?
# passthrough AppUI


func transform_reverse(t: Transform2D, pts: PoolVector2Array) -> PoolVector2Array:
	
	var reverse_t_plus := t;
	reverse_t_plus.origin = -t.get_origin();
	reverse_t_plus.x.x = 1.0;
	reverse_t_plus.y.y = 1.0;
	
	var reverse_t_mult = t;
	if (t.x.x != 0):
		reverse_t_mult.x.x = 1/t.x.x;
	if (t.y.y != 0):
		reverse_t_mult.y.y = 1/t.y.y;
	reverse_t_mult.origin = Vector2.ZERO;
	
	return reverse_t_mult.xform(reverse_t_plus.xform(pts));


func get_vector2_min(u: Vector2, v: Vector2) -> Vector2:
	var temp := u;
	temp[0] = min(temp[0], v[0]);
	temp[1] = min(temp[1], v[1]);
	return temp;

func get_vector2_max(u: Vector2, v: Vector2) -> Vector2:
	var temp := u;
	temp[0] = max(temp[0], v[0]);
	temp[1] = max(temp[1], v[1]);
	return temp;
