extends Node


func _ready():
	# origin (3,5), scale (1,1)
	var t = Transform2D(Vector2(5,0), Vector2(0,5), Vector2(3,0));
	
	var pts = PoolVector2Array([Vector2(3,0),Vector2(4,1),Vector2(5,2),Vector2(8,5)]);
	print("----------------------------------------------------------------");
	print(pts);
	print("--------");
	
	
	var pts_t = t.xform(pts);
	print("t.xform()");
	print(t);
	print(pts_t);
	print("--------");
	
	
	var t_affinv = t.affine_inverse();
	var pts_t_affinv = t_affinv.xform(pts);
	var pts_t_t_affinv = t.affine_inverse().xform(t.xform(pts));
	print("t.affine_inverse().xform()");
	print(t_affinv);
	print(pts_t_affinv);
	print(pts_t_t_affinv);
	print("--------");
	
	var n_pts = transform_reverse(t, pts);
	print(n_pts);
	print("----------------------------------------------------------------");
	

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
