extends Control
class_name 말

var 속한편 :편
var 말번호 :int
var 지나온눈들 :Array[눈]

func string_debug() -> String:
	var s :String = ""
	for n in 지나온눈들:
		s += "%d " % n.번호
	return "말(%s %d 눈[%s])" % [속한편,말번호,s]

func _to_string() -> String:
	return "%s말%d" % [속한편,말번호]

func init(t :편, r :float, n:int, 모양 :int) -> 말:
	속한편 = t
	말번호 = n
	r = r*1.5
	custom_minimum_size = Vector2(r*2,r*2)
	var 내부 = new_polygon_fill(Vector2(r,r),r,t.편색,모양,360)
	add_child(내부)
	var 테두리 = new_polygon(Vector2(r,r),r,Color.BLACK,max(1,r/10),모양,360)
	add_child(테두리)
	var lb = Label.new()
	lb.label_settings = preload("res://label_settings.tres")
	lb.text = "%d" % 말번호
	lb.position = Vector2(r/2,0)
	add_child(lb)
	return self

func 편얻기()->편:
	return 속한편

func 놓을말인가()->bool:
	return 지나온눈들.size() == 0

func 난말인가()->bool:
	return (not 놓을말인가()) and 지나온눈들[-1].번호 == 속한편.길.종점눈번호()

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
	for i in range(0,deg,360/n) :
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
	for i in range(0,deg,360/n) :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		rtn.add_point(v2)
	rtn.default_color = co
	rtn.width = w
	rtn.antialiased = true
	return rtn
