extends Control
class_name 말

var 번호 :int
func init(r :float, co: Color, 번호:int) -> 말:
	self.번호 = 번호
	custom_minimum_size = Vector2(r*3,r*3)
	var 원 = new_circle_fill(Vector2(0,0),r,co)
	add_child(원)
	var lb = Label.new()
	lb.label_settings = preload("res://label_settings.tres")
	lb.text = "%d" % 번호
	lb.position = Vector2(-r/2,-r)
	add_child(lb)
	return self

func _ready() -> void:
	pass

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

func new_circle(p :Vector2, r :float, co :Color, w :float) -> Line2D :
	var rtn = Line2D.new()
	for i in 361 :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		rtn.add_point(v2)
	rtn.default_color = co
	rtn.width = w
	rtn.antialiased = true
	return rtn
