extends Node2D
class_name 윷짝

var 윷_scene = preload("res://윷.tscn")
var 윷들 :Array[윷]
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

	return self

func 윷던지기()->Array[int]:
	var 결과 :Array[int]
	for n in 윷들:
		결과.append( n.던지기() )
	print(결과, 결과해석(결과))
	return 결과

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
