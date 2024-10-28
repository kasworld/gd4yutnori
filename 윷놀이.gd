extends Node2D

var 판_scene = preload("res://판.tscn")
var 말_scene = preload("res://말.tscn")

var vp_size :Vector2
var 판들 : Array[판]

var 편색들 = [Color.RED, Color.GREEN, Color.SKY_BLUE, Color.YELLOW]

func _ready() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9

	$"윷짝".init()
	$"윷짝".position = vp_size/2 + Vector2(-r/2.5,-r/3)
	$"달말들".position = vp_size/2 + Vector2(r/3,r/3)
	$"난말들".position = vp_size/2 + Vector2(-r/3,r/3)
	$"윷던지기".position = vp_size/2 + Vector2(r/8,-r/2)
	for c in 편색들:
		for i in range(1,5):
			$"달말들".add_child(말_scene.instantiate().init(r/30,c,i))
			$"난말들".add_child(말_scene.instantiate().init(r/30,c,i))

	var sh = 10
	판추가(r,Color.WHITE,Vector2(-sh,-sh))
	#판추가(r,Color.SKY_BLUE,Vector2(-sh,sh))
	#판추가(r,Color.GREEN,Vector2(sh,-sh))
	#판추가(r,Color.YELLOW,Vector2(sh,sh))

	for c in 편색들:
		for i in range(0,2):
			판들[0].눈얻기(randi_range(0,28)).말놓기(말_scene.instantiate().init(r/30, c, randi_range(1,4) ))



func 판추가(r:float, co :Color,shift :Vector2):
	var 이번판 = 판_scene.instantiate()
	이번판.init(r, co)
	이번판.position = vp_size/2 + shift
	add_child(이번판)
	판들.append(이번판)
	#이번판.rotation = PI/2 *판들.size()


func _on_윷던지기_pressed() -> void:
	$"윷짝".윷던지기()
