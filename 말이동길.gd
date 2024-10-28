extends Node2D
class_name 말이동길

var r :float
var w :float
var co :Color
var 화살표선들 :PackedVector2Array =[]

# 눈번호
var 바깥길 :Array[int]
var 첫지름길 :Array[int]
var 둘째지름길 :Array[int]
var 세째지름길 :Array[int]

func init(r: float, co :Color, 시작눈 :int, 눈들 :Array[눈]) -> void:
	self.r = r
	self.co = co
	self.w = max(1.0, r/300)

	# 말 이동 순서 연결하기
	match 시작눈:
		0:
			바깥길 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
			첫지름길 = [4,20,21,22,23,24,14]
			둘째지름길 = [9,25,26,22,27,28,19]
			세째지름길 = [22,27,28,19]
		5:
			바깥길 = [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,0,1,2,3,4]
			첫지름길 = [9,25,26,22,27,28,19]
			둘째지름길 = [14,24,23,22,21,20,4]
			세째지름길 = [22,21,20,4]
		10:
			바깥길 = [10,11,12,13,14,15,16,17,18,19,0,1,2,3,4,5,6,7,8,9]
			첫지름길 = [14,24,23,22,21,20,4]
			둘째지름길 = [19,28,27,22,26,25,9]
			세째지름길 = [22,26,25,9]
		15:
			바깥길 = [15,16,17,18,19,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
			첫지름길 = [19,28,27,22,26,25,9]
			둘째지름길 = [4,20,21,22,23,24,14]
			세째지름길 = [22,23,24,14]

		_:
			print("잘못된 시작점입니다.0,5,10,15만 가능")
			get_tree().quit()

	for i in range(0,바깥길.size()-1):
		var p1 = 눈들[바깥길[i]].position
		var p2 = 눈들[바깥길[i+1]].position
		화살표추가(p1,p2)

	for i in range(0,첫지름길.size()-1):
		var p1 = 눈들[첫지름길[i]].position
		var p2 = 눈들[첫지름길[i+1]].position
		화살표추가(p1,p2)

	for i in range(0,둘째지름길.size()-1):
		var p1 = 눈들[둘째지름길[i]].position
		var p2 = 눈들[둘째지름길[i+1]].position
		화살표추가(p1,p2)

	var 중점 = 눈들[22].position

	var 시작점 = 눈들[바깥길[0]].position
	var 시작점0 = ((중점-시작점)*0.3).rotated(-PI/6) + 시작점
	화살표추가(시작점0,시작점)

	var 끝점 = 눈들[바깥길[-1]].position
	var 끝점0 = ((중점-끝점)*0.3).rotated(-PI/6) + 끝점
	화살표추가(끝점,끝점0)

	#var th = 1.0/3.0
	#화살표추가( Vector2(0,r), Vector2(-th*r,r*(1-th)) )
	#화살표추가( Vector2(th*r,r*(1-th)), make_pos_by_rad_r(deg_to_rad(눈각도),r) )
#

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
