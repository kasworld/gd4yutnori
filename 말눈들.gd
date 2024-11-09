extends Node2D
class_name 말눈들

var 눈_scene = preload("res://눈.tscn")

var 눈들 :Array[눈]

func init(반지름: float, co :Color) -> void:
	var 눈반지름 = 반지름/30

	# 눈 추가하기
	var 눈각도 = 360.0/20.0
	for i in range(눈각도,360+눈각도,눈각도):
		var rd = deg_to_rad(i)
		var pos = PolygonNode.make_pos_by_rad_r(rd,반지름)
		눈추가(눈반지름, pos,co)

	for i in [0.66,0.33,0,-0.33,-0.66]:
		눈추가(눈반지름, Vector2(반지름*i,0),co)

	for i in [-0.66,-0.33,0.33,0.66]:
		눈추가(눈반지름, Vector2(0,반지름*i),co)

func 눈추가(눈반지름: float, pos:Vector2, co:Color):
	var 눈1 = 눈_scene.instantiate()
	눈1.init(눈반지름, co, 눈들.size())
	눈1.position = pos
	add_child(눈1)
	눈들.append(눈1)

func 눈얻기(눈번호 :int)->눈:
	return 눈들[눈번호]

func 눈수자보기(b :bool):
	for n in 눈들:
		n.눈수자보기(b)
