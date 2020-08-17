extends Node

# don't reference AppUI, use signals?

#marker management here?
# passthrough AppUI


func transform_reverse(t, pts):
	
	var reverse_t_plus = t;
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
