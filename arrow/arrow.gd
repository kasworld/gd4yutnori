extends Node2D
class_name Arrow

func init_vector(vt :Vector2, co :Color, w :float, wing_size :float=0.2, wing_rotate :float = PI/6) -> Arrow:
	return init_2_point(Vector2.ZERO, vt, co, w, wing_size, wing_rotate)

func init_2_point_center(p1 :Vector2, p2 :Vector2, co :Color, w :float, wing_size :float=0.2, wing_rotate :float = PI/6) -> Arrow:
	var c = (p1+p2)/2
	return init_2_point(p1-c, p2-c, co, w, wing_size, wing_rotate)

func init_2_point(p1 :Vector2, p2 :Vector2, co :Color, w :float, wing_size :float=0.2, wing_rotate :float = PI/6) -> Arrow:
	set_color(co)
	set_width(w)
	make_arrow(p1,p2, wing_size, wing_rotate)
	return self

func make_arrow(p1 :Vector2, p2 :Vector2, wing_size :float=0.2, wing_rotate :float = PI/6):
	$CenterLine.points = [p1,p2]
	add_wing_p2(p1,p2, wing_size, wing_rotate)

func make_arrow_bi(p1 :Vector2, p2 :Vector2, wing_size :float=0.2, wing_rotate :float = PI/6):
	$CenterLine.points = [p1,p2]
	add_wing_p2(p1,p2, wing_size, wing_rotate)
	add_wing_p1(p1,p2, wing_size, wing_rotate)

func add_wing_p1(p1 :Vector2, p2 :Vector2, wing_size :float=0.2, wing_rotate :float = PI/6):
	var p3 = ((p2-p1)*wing_size).rotated(wing_rotate) + p1
	$P1_W1.points = [p1,p3]
	var p4 = ((p2-p1)*wing_size).rotated(-wing_rotate) + p1
	$P1_W2.points = [p1,p4]
	$P1_W1.visible = true
	$P1_W2.visible = true

func add_wing_p2(p1 :Vector2, p2 :Vector2, wing_size :float=0.2, wing_rotate :float = PI/6):
	var p3 = ((p1-p2)*wing_size).rotated(wing_rotate) + p2
	$P2_W1.points = [p2,p3]
	var p4 = ((p1-p2)*wing_size).rotated(-wing_rotate) + p2
	$P2_W2.points = [p2,p4]
	$P2_W1.visible = true
	$P2_W2.visible = true

func set_color(co :Color):
	$CenterLine.default_color = co
	$P2_W1.default_color = co
	$P2_W2.default_color = co
	$P1_W1.default_color = co
	$P1_W2.default_color = co

func set_width(w :float):
	$CenterLine.width = w
	$P2_W1.width = w
	$P2_W2.width = w
	$P1_W1.width = w
	$P1_W2.width = w
