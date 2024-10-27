extends Node2D

var 판_scene = preload("res://판.tscn")
var 말_scene = preload("res://말.tscn")
var 윷_scene = preload("res://윷.tscn")


var vp_size :Vector2
var 판들 : Array[판]
var 윷들 : Array[윷]

func _ready() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9

	for i in range(0,4):
		$"윷통".add_child(윷_scene.instantiate().init())
	$"윷통".position = vp_size/2 + Vector2(-r/2.5,-r/3)
	$"달말들".position = vp_size/2 + Vector2(r/3,r/3)
	$"난말들".position = vp_size/2 + Vector2(-r/3,r/3)
	for c in [Color.RED, Color.GREEN, Color.SKY_BLUE, Color.YELLOW]:
		for i in range(1,5):
			$"달말들".add_child(말_scene.instantiate().init(r/30,c,i))
			$"난말들".add_child(말_scene.instantiate().init(r/30,c,i))

	var sh = 10
	판추가(r,Color.WHITE,Vector2(-sh,-sh))
	#판추가(r,Color.SKY_BLUE,Vector2(-sh,sh))
	#판추가(r,Color.GREEN,Vector2(sh,-sh))
	#판추가(r,Color.YELLOW,Vector2(sh,sh))

	판들[0].눈얻기(3).말놓기(말_scene.instantiate().init(r/30,Color.RED,1))
	판들[0].눈얻기(26).말놓기(말_scene.instantiate().init(r/30,Color.RED,3))
	판들[0].눈얻기(7).말놓기(말_scene.instantiate().init(r/30,Color.GREEN,2))
	판들[0].눈얻기(17).말놓기(말_scene.instantiate().init(r/30,Color.GREEN,2))
	판들[0].눈얻기(12).말놓기(말_scene.instantiate().init(r/30,Color.SKY_BLUE,1))
	판들[0].눈얻기(21).말놓기(말_scene.instantiate().init(r/30,Color.SKY_BLUE,2))
	판들[0].눈얻기(22).말놓기(말_scene.instantiate().init(r/30,Color.YELLOW,3))
	판들[0].눈얻기(27).말놓기(말_scene.instantiate().init(r/30,Color.YELLOW,1))



func 판추가(r:float, co :Color,shift :Vector2):
	var 이번판 = 판_scene.instantiate()
	이번판.init(r, co)
	이번판.position = vp_size/2 + shift
	add_child(이번판)
	판들.append(이번판)
	#이번판.rotation = PI/2 *판들.size()
