extends Node2D

var 편_scene = preload("res://편.tscn")
var 말이동길_scene = preload("res://말이동길.tscn")

var vp_size :Vector2

var 편색들 = [Color.RED, Color.GREEN, Color.SKY_BLUE, Color.YELLOW]
var 말이동길들 :Array[말이동길]

var 편들 :Array[편]

@onready var 달말통 = $"판밖말들/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer"
@onready var 난말통 = $"판밖말들/HBoxContainer/PanelContainer2/VBoxContainer2/VBoxContainer"

func _ready() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9

	$"말눈들".init(r,Color.WHITE)
	$"말눈들".position = vp_size/2
	$"윷짝".init()
	$"윷짝".position = vp_size/2 + Vector2(-r/2.3,-r/3)
	$"윷던지기".position = vp_size/2 + Vector2(r/8,-r/2)
	$"판밖말들".position = vp_size/2 + Vector2(-r/2,r/4)

	for co in 편색들:
		말이동길추가(r,co)

	for c in 편색들:
		var t = 편_scene.instantiate()
		var n1 = HBoxContainer.new()
		달말통.add_child(n1)
		var n2 = HBoxContainer.new()
		난말통.add_child(n2)
		t.init(NamedColorList.get_colorname_by_color(c), 4, r/30, c,n1,n2)
		편들.append(t)

	for t in 편들:
		while true:
			var m = t.놓을말얻기()
			if m == null:
				break
			var n = $"말눈들".눈얻기(randi_range(0,28))
			var oldms = n.말놓기([m])
			for om in oldms:
				om.편얻기().놓을말되돌려넣기(om)

	말이동길보이기변경()

func _on_윷던지기_pressed() -> void:
	$"윷짝".윷던지기()
	var 결과 = $"윷짝".결과얻기()
	말이동길보이기변경()

func 말이동길추가(r :float, co :Color):
	var o = 말이동길_scene.instantiate()
	var v = [0,1,2,3,5,6,7,8,10,11,12,13,15,16,17,18].pick_random()
	o.init(r, co, $"말눈들".눈들, v, randi_range(0,1)==0)
	o.position = vp_size/2
	add_child(o)
	말이동길들.append(o)

var 지금보이는말이동길번호 =0
func 말이동길보이기변경():
	for i in 말이동길들:
		i.visible = false
	지금보이는말이동길번호 +=1
	지금보이는말이동길번호 %= 말이동길들.size()
	말이동길들[지금보이는말이동길번호].visible = true
