extends Node

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)

func new_circle_fill(p :Vector2, r :float, co:Color) -> Polygon2D :
	return alter_polygon_fill(Polygon2D.new(),p,r,co,360,360)

func new_polygon_fill(p :Vector2, r :float, co :Color, n:int, deg:float) -> Polygon2D :
	return alter_polygon_fill(Polygon2D.new(),p,r,co,n,deg)

func alter_polygon_fill(o :Polygon2D, p :Vector2, r :float, co :Color, n:int, deg:float) -> Polygon2D:
	var pv2a : PackedVector2Array = []
	var step = deg/n
	for i in range(0+step/2,deg+step/2,step) :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		pv2a.append(v2)
	o.polygon = pv2a
	o.color = co
	o.antialiased = true
	return o

func new_circle(p :Vector2, r :float, co :Color, w :float) -> Line2D :
	return alter_polygon(Line2D.new(),p,r,co,w,360,360)

func new_polygon(p :Vector2, r :float, co :Color, w :float, n:int, deg:float) -> Line2D :
	return alter_polygon(Line2D.new(),p,r,co,w,n,deg)

func alter_polygon(o :Line2D, p :Vector2, r :float, co :Color, w :float, n:int, deg:float) -> Line2D :
	var step = deg/n
	for i in range(0+step/2,deg+step/2,step) :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		o.add_point(v2)
	o.default_color = co
	o.width = w
	o.antialiased = true
	return o
