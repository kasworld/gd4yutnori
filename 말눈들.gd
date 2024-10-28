extends Node2D

class_name 말눈들

var 눈_scene = preload("res://눈.tscn")

var r :float
var w :float
var co :Color

var 눈들 :Array[눈]

func init(r: float, co :Color) -> void:
	self.r = r
	self.co = co
	self.w = max(1.0, r/300)

	# 눈 추가하기
	var 눈각도 = 360/20
	for i in range(눈각도,360+눈각도,눈각도):
		var rd = deg_to_rad(i)
		var pos = make_pos_by_rad_r(rd,r)
		눈추가(r,pos,co)

	for i in [0.66,0.33,0,-0.33,-0.66]:
		눈추가(r,Vector2(r*i,0),co)

	for i in [-0.66,-0.33,0.33,0.66]:
		눈추가(r,Vector2(0,r*i),co)


func 눈추가(r: float, pos:Vector2,co:Color):
	var 눈1 = 눈_scene.instantiate()
	눈1.init(r/30, co, 눈들.size())
	눈1.position = pos
	add_child(눈1)
	눈들.append(눈1)

func 눈얻기(눈번호 :int)->눈:
	return 눈들[눈번호]

func _ready() -> void:
	pass

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)
