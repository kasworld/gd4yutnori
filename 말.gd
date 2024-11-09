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
	custom_minimum_size = Vector2(r*2,r*2)
	r = r*1.4
	var 내부 = PolygonNode.new_polygon_fill(Vector2(r,r),r,t.편색,모양,360)
	add_child(내부)
	var 테두리 = PolygonNode.new_polygon(Vector2(r,r),r*1.1,Color.BLACK,max(1,r/10),모양,360)
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
