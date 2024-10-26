extends Node2D

var 판_scene = preload("res://판.tscn")

var vp_size :Vector2
var 판들 : Array[판]


func _ready() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9
	var sh = r/20
	판추가(r,Color.RED,Vector2(-sh,-sh))
	#판추가(r,Color.BLUE,Vector2(-sh,sh))
	#판추가(r,Color.GREEN,Vector2(sh,-sh))
	#판추가(r,Color.YELLOW,Vector2(sh,sh))

func 판추가(r:float, co :Color,shift :Vector2):
	var 이번판 = 판_scene.instantiate()
	이번판.init(r, co)
	이번판.position = vp_size/2 + shift
	add_child(이번판)
	판들.append(이번판)
	#이번판.rotation = PI/2 *판들.size()
