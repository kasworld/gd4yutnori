extends Node

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)

func new_circle_fill(p :Vector2, r :float, co:Color) -> Polygon2D :
	var rtn = Polygon2D.new()
	var pv2a : PackedVector2Array = []
	for i in 360 :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		pv2a.append(v2)
	rtn.polygon = pv2a
	rtn.color = co
	rtn.antialiased = true
	return rtn

func new_polygon_fill(p :Vector2, r :float, co :Color, n:int, deg:float) -> Polygon2D :
	var rtn = Polygon2D.new()
	var pv2a : PackedVector2Array = []
	var step = deg/n
	for i in range(0+step/2,deg+step/2,step) :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		pv2a.append(v2)
	rtn.polygon = pv2a
	rtn.color = co
	rtn.antialiased = true
	return rtn

func new_circle(p :Vector2, r :float, co :Color, w :float) -> Line2D :
	var rtn = Line2D.new()
	for i in 361 :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		rtn.add_point(v2)
	rtn.default_color = co
	rtn.width = w
	rtn.antialiased = true
	return rtn

func new_polygon(p :Vector2, r :float, co :Color, w :float, n:int, deg:float) -> Line2D :
	var rtn = Line2D.new()
	var step = deg/n
	for i in range(0+step/2,deg+step/2,step) :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		rtn.add_point(v2)
	rtn.default_color = co
	rtn.width = w
	rtn.antialiased = true
	return rtn
