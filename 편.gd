extends PanelContainer
class_name 편

@onready var 놓을말통 = $HBoxContainer/HBoxContainer
@onready var 난말통 = $HBoxContainer/HBoxContainer2
@onready var 길단추 = $HBoxContainer/Button

var 말_scene = preload("res://말.tscn")
var 말이동길_scene = preload("res://말이동길.tscn")

var 편이름 :String
var 편색 :Color
var 눈들 :말눈들
var 길 :말이동길

var 말들 :Array[말]
var 놓을말 :Array[말]
var 난말 :Array[말]

func init(이름 :String, 말수 :int, 크기:float, co:Color, es :말눈들) -> void:
	편이름 = 이름
	편색 = co
	눈들 = es
	길 = 말이동길_scene.instantiate()
	var v = 말이동길.가능한시작눈목록.pick_random()
	길.init(크기, co, es.눈들, v, randi_range(0,1)==0)

	var r = 크기/30
	custom_minimum_size = Vector2(r*2*10,r*2)
	놓을말통.custom_minimum_size = Vector2(r*2*4,r*2)
	난말통.custom_minimum_size = Vector2(r*2*4,r*2)
	길단추.text = 이름
	길단추.modulate = co
	for i in range(0,말수):
		var m = 말_scene.instantiate().init(self, r, co, i+1)
		놓을말.append(m)
		놓을말통.add_child(m)
	말들 = 놓을말.duplicate()

func 놓을말얻기()->말:
	if 놓을말.size() == 0:
		print("놓을말이 없습니다.", 편이름)
		return null
	var m = 놓을말.pop_front()
	놓을말통.remove_child(m)
	return m

func 놓을말되돌려넣기(m :말):
	놓을말.push_back(m)
	놓을말통.add_child(m)

func 난말넣기(m :말):
	난말.push_back(m)
	난말통.add_child(m)

func 새로말달기(이동거리 :int)->눈:
	var m = 놓을말얻기()
	if m == null:
		return null
	var 목적눈번호 = 길.말이동위치찾기(-1,이동거리)
	var n = 눈들.눈얻기(목적눈번호)
	var oldms = n.말놓기([m])
	for om in oldms:
		om.편얻기().놓을말되돌려넣기(om)
	return n
