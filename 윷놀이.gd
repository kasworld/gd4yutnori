extends Node2D

var 말_scene = preload("res://말.tscn")

var vp_size :Vector2

var 편색들 = [Color.RED, Color.GREEN, Color.SKY_BLUE, Color.YELLOW]

func _ready() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9

	$"말눈들".init(r,Color.WHITE)
	$"말눈들".position = vp_size/2

	$"말이동길".init(r,Color.WHITE, 3, $"말눈들".눈들)
	$"말이동길".position = vp_size/2

	$"윷짝".init()
	$"윷짝".position = vp_size/2 + Vector2(-r/2.3,-r/3)
	$"달말들".position = vp_size/2 + Vector2(r/3,r/3)
	$"난말들".position = vp_size/2 + Vector2(-r/3,r/3)
	$"윷던지기".position = vp_size/2 + Vector2(r/8,-r/2)
	for c in 편색들:
		for i in range(1,5):
			$"달말들".add_child(말_scene.instantiate().init(r/30,c,i))
			$"난말들".add_child(말_scene.instantiate().init(r/30,c,i))

	for c in 편색들:
		for i in range(0,2):
			$"말눈들".눈얻기(randi_range(0,28)).말놓기(말_scene.instantiate().init(r/30, c, randi_range(1,4) ))


func _on_윷던지기_pressed() -> void:
	$"윷짝".윷던지기()
