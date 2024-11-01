extends Node2D

const 편인자들 = [
	["빨강색", Color.RED],
	["초록색", Color.GREEN],
	["하늘색", Color.SKY_BLUE],
	["노랑색", Color.YELLOW],
]
const 편당말수 = 4
@onready var 편통 = $"판밖말들/VBoxContainer2/VBoxContainer"
var 편_scene = preload("res://편.tscn")
var 편들 :Array[편]

func _ready() -> void:
	var vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9

	$"말눈들".init(r,Color.WHITE)
	$"말눈들".position = vp_size/2
	$"윷짝".init()
	$"윷짝".position = vp_size/2 + Vector2(-r/2.3,-r/3)
	$"윷던지기".position = vp_size/2 + Vector2(r/8,-r/2)
	$"판밖말들".position = vp_size/2 + Vector2(-r*0.8,r*0.1)

	# 편 가르기
	for ti in 편인자들:
		var t = 편_scene.instantiate()
		편통.add_child(t)
		t.init(ti[0], 편당말수, r, ti[1], $"말눈들")
		편들.append(t)
		t.길.position = vp_size/2
		add_child(t.길)

		t.길단추.pressed.connect(
			func():
				self.말이동길보이기(t)
				)

	말이동길보이기(편들[0])
	$"윷던지기".modulate = 편들[0].편색

func 말이동길보이기(t:편) ->void:
	for i in 편들:
		i.길.visible = false
	t.길.visible = true

var 이번윷던질편번호 =0
func 다음말이동길보이기():
	이번윷던질편번호 +=1
	이번윷던질편번호 %= 편들.size()
	말이동길보이기(편들[이번윷던질편번호])
	$"윷던지기".modulate = 편들[이번윷던질편번호].편색

func _on_윷던지기_pressed() -> void:
	$"윷짝".윷던지기()
	var 결과 = $"윷짝".결과얻기()
	if 편들[이번윷던질편번호].새로말달기(결과) == null:
		#print("놓을말이 없습니다.", 편이름)
		편들[이번윷던질편번호].판위의말이동하기(결과)
	다음말이동길보이기()
