extends Node2D
class_name 편

var 말_scene = preload("res://말.tscn")

var 편이름 :String
var 편색 :Color
var 놓을말 :Array[말]
var 난말 :Array[말]

func init(이름:String, 말수 :int, r:float, co:Color) -> void:
	편이름 = 이름
	편색 = co
	for i in range(0,말수):
		var m = 말_scene.instantiate().init(self, r, co, i+1)
		놓을말.append(m)

func 놓을말얻기()->말:
	if 놓을말.size() == 0:
		print("놓을말이 없습니다.", 편이름)
		return null
	return 놓을말.pop_front()

func 놓을말되돌려넣기(m :말):
	놓을말.push_back(m)

func 난말넣기(m :말):
	난말.push_back(m)
