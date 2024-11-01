extends Node2D
class_name 윷짝

var 윷_scene = preload("res://윷.tscn")

const 결과문자변환 = {
	-3:"뒷걸",
	-2:"뒷개",
	-1:"뒷도",
	1:"도",
	2:"개",
	3:"걸",
	4:"윷",
	5:"모",
}

var 윷들 :Array[윷]
var 결과label :Label
var 결과수치 :int

func init()->윷짝:
	for i in ["뒷도","뒷개","뒷걸","도","결과"]:
		var lb = Label.new()
		lb.label_settings = preload("res://label_settings.tres")
		lb.text = i
		$"윷통".add_child(lb)

	for i in range(0,4):
		var n = 윷_scene.instantiate().init()
		$"윷통".add_child(n)
		윷들.append(n)

	var lb = Label.new()
	lb.label_settings = preload("res://label_settings.tres")
	lb.text = "모"
	$"윷통".add_child(lb)
	결과label = lb

	return self

func 윷던지기():
	var 결과 :Array[int]
	for n in 윷들:
		결과.append( n.던지기() )
	결과수치 = 결과해석(결과)
	결과label.text = 결과문자변환[결과수치]

func 결과얻기()->int:
	return 결과수치

func 결과해석(결과 :Array[int])->int:
	if 결과 == [1,0,0,0]:
		return -1
	if 결과 == [1,1,0,0]:
		return -2
	if 결과 == [1,0,1,0]:
		return -2
	if 결과 == [1,1,1,0]:
		return -3
	if 결과 == [0,0,0,0]:
		return 5
	var sum = 0
	for i in 결과:
		sum += i
	return sum

func 한번더던지나(결과 :int)->bool:
	return 결과==5 or 결과 == 4
