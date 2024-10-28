extends Node2D
class_name 말이동길

var r :float
var w :float
var co :Color
var 화살표선들 :PackedVector2Array =[]

var 바깥길 :Array[int]
var 첫지름길 :Array[int]
var 둘째지름길 :Array[int]
var 세째지름길 :Array[int]

func init(r: float, co :Color) -> void:
	self.r = r
	self.co = co
	self.w = max(1.0, r/300)

	var 눈각도 = 360/20

	# 말 이동 순서 연결하기
	바깥길 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
	첫지름길 = [4,20,21,22,23,24,14]
	둘째지름길 = [9,25,26,22,27,28,19]
	세째지름길 = [22,27,28,19]

	# 눈 연결선 그리기
	for i in range(눈각도,360,눈각도):
		var rd1 = deg_to_rad(i)
		var rd2 = deg_to_rad(i+눈각도)
		화살표추가(make_pos_by_rad_r(rd1,r),make_pos_by_rad_r(rd2,r))
	#화살표추가(make_pos_by_rad_r(0,r),make_pos_by_rad_r(0,r*2))

	var th = 1.0/3.0
	화살표추가( Vector2(0,r), Vector2(-th*r,r*(1-th)) )
	화살표추가( Vector2(th*r,r*(1-th)), make_pos_by_rad_r(deg_to_rad(눈각도),r) )

	for i in [-1.0,-th*2,-th,0,th,th*2]:
		# 세로 화살표
		화살표추가(Vector2(0,r*i),Vector2(0,r*(i+th)))
		# 가로 화살표
		화살표추가(Vector2(r*(i+th),0),Vector2(r*i,0))

func 화살표추가(p1 :Vector2, p2 :Vector2):
	var t1 = (p2-p1)*0.8+p1
	var t2 = (p1-p2)*0.8+p2
	p1 = t2
	p2 = t1
	화살표선들.append_array([p1,p2])
	var p3 = ((p1-p2)*0.2).rotated(PI/6) + p2
	var p4 = ((p1-p2)*0.2).rotated(-PI/6) + p2
	화살표선들.append_array([p3,p2])
	화살표선들.append_array([p4,p2])

func _draw() -> void:
	draw_multiline(화살표선들,co, self.w)

func _ready() -> void:
	pass

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)
