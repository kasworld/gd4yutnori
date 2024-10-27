extends Node2D

var 판_scene = preload("res://판.tscn")
var 말_scene = preload("res://말.tscn")

var vp_size :Vector2
var 판들 : Array[판]


func _ready() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9
	var sh = 10
	판추가(r,Color.WHITE,Vector2(-sh,-sh))
	#판추가(r,Color.SKY_BLUE,Vector2(-sh,sh))
	#판추가(r,Color.GREEN,Vector2(sh,-sh))
	#판추가(r,Color.YELLOW,Vector2(sh,sh))

	판들[0].눈얻기(3).말놓기(말_scene.instantiate().init(r/30,Color.RED,0))
	판들[0].눈얻기(26).말놓기(말_scene.instantiate().init(r/30,Color.RED,0))
	판들[0].눈얻기(7).말놓기(말_scene.instantiate().init(r/30,Color.GREEN,0))
	판들[0].눈얻기(17).말놓기(말_scene.instantiate().init(r/30,Color.GREEN,0))
	판들[0].눈얻기(12).말놓기(말_scene.instantiate().init(r/30,Color.SKY_BLUE,0))
	판들[0].눈얻기(21).말놓기(말_scene.instantiate().init(r/30,Color.SKY_BLUE,0))
	판들[0].눈얻기(22).말놓기(말_scene.instantiate().init(r/30,Color.YELLOW,0))
	판들[0].눈얻기(27).말놓기(말_scene.instantiate().init(r/30,Color.YELLOW,0))



func 판추가(r:float, co :Color,shift :Vector2):
	var 이번판 = 판_scene.instantiate()
	이번판.init(r, co)
	이번판.position = vp_size/2 + shift
	add_child(이번판)
	판들.append(이번판)
	#이번판.rotation = PI/2 *판들.size()
