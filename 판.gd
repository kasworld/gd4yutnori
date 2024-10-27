extends Node2D
class_name 판

var 눈_scene = preload("res://눈.tscn")

var r :float
var co :Color
var 화살표선들 :PackedVector2Array =[]

var 눈들 :Array[눈]
var 바깥길 :Array[int]
var 첫지름길 :Array[int]
var 둘째지름길 :Array[int]
var 세째지름길 :Array[int]

func init(r: float, co :Color) -> void:
	self.r = r
	self.co = co

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

	# 말 이동 순서 연결하기
	바깥길 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
	첫지름길 = [4,20,21,22,23,24,14]
	둘째지름길 = [9,25,26,22,27,28,19]
	세째지름길 = [22,27,28,19]

	# 눈 연결선 그리기
	for i in range(0,360,눈각도):
		var rd1 = deg_to_rad(i)
		var rd2 = deg_to_rad(i+눈각도)
		화살표선들.append_array([make_pos_by_rad_r(rd1,r),make_pos_by_rad_r(rd2,r)])
	var th = 1.0/3.0
	for i in [-1.0,-th*2,-th,0,th,th*2]:
		화살표선들.append_array([Vector2(r*i,0),Vector2(r*(i+0.33),0)])
		화살표선들.append_array([Vector2(0,r*i),Vector2(0,r*(i+0.33))])


func 눈추가(r: float, pos:Vector2,co:Color):
	var 눈1 = 눈_scene.instantiate()
	눈1.init(r/30, co, 눈들.size())
	눈1.position = pos
	add_child(눈1)
	눈들.append(눈1)

func 눈얻기(눈번호 :int)->눈:
	return 눈들[눈번호]

func _draw() -> void:
	draw_multiline(화살표선들,co, 1)


func _ready() -> void:
	pass

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)
