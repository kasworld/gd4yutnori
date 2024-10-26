extends Node2D

var 눈_scene = preload("res://눈.tscn")

var r :float
var co :Color
var 화살표선들 :PackedVector2Array =[]

var 눈들 :Array[눈]

func init(r: float, co :Color) -> void:
	self.r = r
	self.co = co

	# 눈 추가하기
	var 눈각도 = 360/20
	for i in range(눈각도,360+눈각도,눈각도):
		var rd = deg_to_rad(i)
		var pos = make_pos_by_rad_r(rd,r)
		눈추가(r,pos,co)

	for i in [-0.33,-0.66,0.33,0.66]:
		눈추가(r,Vector2(r*i,0),co)
		눈추가(r,Vector2(0,r*i),co)

	눈추가(r,Vector2(0,0),co)

	# 눈 연결선 그리기
	for i in range(0,360,눈각도):
		var rd1 = deg_to_rad(i)
		var rd2 = deg_to_rad(i+눈각도)
		화살표선들.append_array([make_pos_by_rad_r(rd1,r),make_pos_by_rad_r(rd2,r)])
	for i in [-1.0,-0.33,-0.66,0,0.33,0.66]:
		화살표선들.append_array([Vector2(r*i,0),Vector2(r*(i+0.33),0)])
		화살표선들.append_array([Vector2(0,r*i),Vector2(0,r*(i+0.33))])

	# 말 이동 순서 연결하기
	for i in range(0,19):
		눈들[i].다음눈 = 눈들[i+1]

	눈들[26].다음눈 = 눈들[24]
	눈들[24].다음눈 = 눈들[28]
	눈들[28].다음눈 = 눈들[20]
	눈들[20].다음눈 = 눈들[22]
	눈들[22].다음눈 = 눈들[14]
	눈들[23].다음눈 = 눈들[21]
	눈들[21].다음눈 = 눈들[28]
	눈들[25].다음눈 = 눈들[27]
	눈들[27].다음눈 = 눈들[19]

	눈들[4].지름길눈 = 눈들[26]
	눈들[9].지름길눈 = 눈들[23]
	눈들[28].지름길눈 = 눈들[25]


func 눈추가(r: float, pos:Vector2,co:Color):
	var 눈1 = 눈_scene.instantiate()
	눈1.init(r/30, co, 눈들.size())
	눈1.position = pos
	add_child(눈1)
	눈들.append(눈1)

func _draw() -> void:
	draw_multiline(화살표선들,co, 1)


func _ready() -> void:
	pass

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)
