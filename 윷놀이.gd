extends Node2D

var 판_scene = preload("res://판.tscn")

var vp_size :Vector2

func _ready() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9
	var 이번판 = 판_scene.instantiate()
	이번판.init(r, Color.RED)
	이번판.position = vp_size/2
	add_child(이번판)
