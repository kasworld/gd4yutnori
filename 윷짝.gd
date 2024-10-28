extends Node2D
class_name 윷짝

var 윷_scene = preload("res://윷.tscn")

func init()->윷짝:
	for i in range(0,4):
		$"윷통".add_child(윷_scene.instantiate().init())
	return self

func 윷던지기():
	for n in $"윷통".get_children():
		n.던지기()
