extends Node2D
class_name Arrow

func init_vector(vt :Vector2, co :Color, w :float, wing_size :float=1, wing_rotate :float = PI/6) -> Arrow:
	return init_2_point(Vector2.ZERO, vt, co, w, wing_size, wing_rotate)

func init_2_point_center(p1 :Vector2, p2 :Vector2, co :Color, w :float, wing_size :float=1, wing_rotate :float = PI/6) -> Arrow:
	var c = (p1+p2)/2
	return init_2_point(p1-c, p2-c, co, w, wing_size, wing_rotate)

func init_2_point(p1 :Vector2, p2 :Vector2, co :Color, w :float, wing_size :float=1, wing_rotate :float = PI/6) -> Arrow:
	set_color(co)
	set_width(w)
	make_arrow(p1,p2, wing_size, wing_rotate)
	return self

func make_arrow(p1 :Vector2, p2 :Vector2, wing_size :float=1, wing_rotate :float = PI/6):
	$CenterLine.points = [p1,p2]
	add_wing_p2(p1,p2, wing_size, wing_rotate)

func make_arrow_bi(p1 :Vector2, p2 :Vector2, wing_size :float=1, wing_rotate :float = PI/6):
	$CenterLine.points = [p1,p2]
	add_wing_p2(p1,p2, wing_size, wing_rotate)
	add_wing_p1(p1,p2, wing_size, wing_rotate)

func add_wing_p1(p1 :Vector2, p2 :Vector2, wing_size :float=1, wing_rotate :float = PI/6):
	var w_vt = (p2-p1).normalized()*wing_size
	var p3 = w_vt.rotated(wing_rotate) + p1
	var p4 = w_vt.rotated(-wing_rotate) + p1
	$Wing1.points = [p4,p1,p3]
	$Wing1.visible = true

func add_wing_p2(p1 :Vector2, p2 :Vector2, wing_size :float=1, wing_rotate :float = PI/6):
	var w_vt = (p1-p2).normalized()*wing_size
	var p3 = w_vt.rotated(wing_rotate) + p2
	var p4 = w_vt.rotated(-wing_rotate) + p2
	$Wing2.points = [p4,p2,p3]
	$Wing2.visible = true

func set_color(co :Color):
	$CenterLine.default_color = co
	$Wing2.default_color = co
	$Wing1.default_color = co

func set_width(w :float):
	$CenterLine.width = w
	$Wing2.width = w
	$Wing1.width = w
