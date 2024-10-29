extends Node2D

var 말_scene = preload("res://말.tscn")
var 말이동길_scene = preload("res://말이동길.tscn")

var vp_size :Vector2

var 편색들 = [Color.RED, Color.GREEN, Color.SKY_BLUE, Color.YELLOW]
var 말이동길들 :Array[말이동길]

func _ready() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9

	$"말눈들".init(r,Color.WHITE)
	$"말눈들".position = vp_size/2
	$"윷짝".init()
	$"윷짝".position = vp_size/2 + Vector2(-r/2.3,-r/3)
	$"달말들".position = vp_size/2 + Vector2(r/3,r/3)
	$"난말들".position = vp_size/2 + Vector2(-r/3,r/3)
	$"윷던지기".position = vp_size/2 + Vector2(r/8,-r/2)

	for co in 편색들:
		말이동길추가(r,co)

	for c in 편색들:
		for i in range(1,5):
			$"달말들".add_child(말_scene.instantiate().init(r/30,c,i))
			$"난말들".add_child(말_scene.instantiate().init(r/30,c,i))

	for c in 편색들:
		for i in range(0,2):
			$"말눈들".눈얻기(randi_range(0,28)).말놓기(말_scene.instantiate().init(r/30, c, randi_range(1,4) ))


func _on_윷던지기_pressed() -> void:
	$"윷짝".윷던지기()


func 말이동길추가(r :float, co :Color):
	var o = 말이동길_scene.instantiate()
	var v = [0,1,2,3,5,6,7,8,10,11,12,13,15,16,17,18].pick_random()
	o.init(r, co, $"말눈들".눈들, v, randi_range(0,1)==0)
	o.position = vp_size/2
	add_child(o)
	말이동길들.append(o)

var i길 =0
func _on_timer_timeout() -> void:
	for i in 말이동길들:
		i.visible = false
	i길 +=1
	i길 %= 말이동길들.size()
	말이동길들[i길].visible = true
