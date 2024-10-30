extends Control
class_name 눈

var 번호 :int
var w :float
func init(r :float, co: Color, 번호:int) -> void:
	self.번호 = 번호
	self.w = max(1,r/8)
	var 원 = new_circle(Vector2(0,0),r,co,self.w)
	add_child(원)
	var lb = Label.new()
	lb.label_settings = preload("res://label_settings.tres")
	lb.text = "%d" % 번호
	add_child(lb)

func 말놓기(놓을말들 :Array)->Array[말]:
	var 있던말들 :Array[말]
	if 놓을말들.size() == 0 :
		print("놓을말들이 비어있습니다.", 번호)
		return 있던말들
	if $"말들".get_child_count() != 0 and $"말들".get_children()[0].편얻기() != 놓을말들[0].편얻기():
		있던말들 = 말빼기()

	for m in 놓을말들:
		$"말들".add_child(m)
		m.위치한눈 = self
	return 있던말들

func 말빼기()->Array[말]:
	var rtn :Array[말]
	for m in $"말들".get_children():
		rtn.append(m)
		$"말들".remove_child(m)
		m.위치한눈 = null
	return rtn

func 말보기()->Array[말]:
	var rtn :Array[말]
	for m in $"말들".get_children():
		rtn.append(m)
	return rtn

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
