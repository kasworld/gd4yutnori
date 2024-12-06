extends Node2D

@onready var 편통 = $"오른쪽패널/편들상태/내용"
@onready var 진행사항 = $"왼쪽패널/ScrollContainer/진행사항"
@onready var 윷던지기 = $"오른쪽패널/윷던지기"
@onready var 윷짝1 = $"오른쪽패널/윷짝"

var 편_scene = preload("res://편.tscn")
var msma_scene = preload("res://multi_section_move_animation/multi_section_move_animation.tscn")
var 말_scene = preload("res://말.tscn")

var 편들 :Array[편]
var vp_size
func init() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9
	$"배경".size = vp_size*2
	$"말판".position = vp_size/2
	$"말판/말눈들".init(r, Color.GRAY)
	#$"말판/말눈들".position = vp_size/2
	윷짝1.init()
	$왼쪽패널.size = Vector2(vp_size.x/2 -r*1.1, vp_size.y)
	$오른쪽패널.size = Vector2(vp_size.x/2 -r*1.1, vp_size.y)
	$오른쪽패널.position = Vector2(vp_size.x/2 + r*1.1, 0)

	Settings.편인자들.shuffle()
	# 편 가르기
	for ti in Settings.편인자들:
		var t = 편_scene.instantiate()
		편통.add_child(t)
		var 시작눈 = 말이동길.가능한시작눈목록.pick_random()
		var mirror = randi_range(0,1)==0
		t.init(ti,Settings.편당말수, r, $"말판/말눈들", 시작눈, mirror)
		편들.append(t)
		$"말판".add_child(t.길)
		t.길단추.pressed.connect(
			func():
				self.말이동길보이기(t)
				)

	말이동길보이기(편들[0])
	윷던지기.modulate = 편들[0].인자.색
	윷던지기.text = "%s편\n윷던지기" % 편들[0].인자.이름

	$"왼쪽패널/자동진행".button_pressed = Settings.자동진행
	$"왼쪽패널/길보기".button_pressed = Settings.모든길보기
	$"왼쪽패널/눈번호보기".button_pressed = Settings.눈번호보기
	if Settings.자동진행:
		윷던지고말이동하기()

func _ready() -> void:
	init()

func _process(_delta: float) -> void:
	rot_by_accel()
	scroll_bg()

var bg_scroll_vt := Vector2(1,0).rotated(randfn(0,PI))
const scroll_wrap = Vector2(512,512)
func scroll_bg():
	if randf() < 0.05 :
		bg_scroll_vt = bg_scroll_vt.rotated(randfn(0,PI/16))
	$"배경".position += bg_scroll_vt
	$"배경".position -= scroll_wrap
	$"배경".position.x = fmod($"배경".position.x, scroll_wrap.x)
	$"배경".position.y = fmod($"배경".position.y, scroll_wrap.y)

var old_rotation_vector := Vector2(0,-100)
func rot_by_accel()->void:
	var vt = Input.get_accelerometer()
	if  vt != Vector3.ZERO :
		old_rotation_vector = (Vector2(vt.x,vt.y) + old_rotation_vector).normalized() *100
		var rad = old_rotation_vector.angle_to(Vector2(0,-1))
		rotate_all(rad)
	else :
		vt = Input.get_last_mouse_velocity()/100
		if vt == Vector2.ZERO :
			vt = Vector2(0,-5)
		old_rotation_vector = (Vector2(vt.x,vt.y) + old_rotation_vector).normalized() *100
		var rad = old_rotation_vector.angle_to(Vector2(0,-1))
		rotate_all(rad)

func rotate_all(rad :float):
	$"말판".rotation = rad

func 말이동길보이기(t:편) ->void:
	if Settings.모든길보기:
		말이동길모두보기()
	else:
		for i in 편들:
			i.길.visible = false
		t.길.visible = true
		t.길.position = Vector2.ZERO

func 말이동길모두보기() ->void:
	var deg_start = 30.0
	var deg_inc = 360.0 / 편들.size()
	var r = min(vp_size.x,vp_size.y)/2 * 0.03
	var i = 0
	for t in 편들:
		t.길.visible = true
		var ra = deg_to_rad( deg_start + i*deg_inc)
		t.길.position = PolygonNode.make_pos_by_rad_r(ra,r)
		i+=1

var 이번윷던질편번호 =0
var 난편들 :Array[편]
func 다음편차례준비하기():
	while true:
		if 난편들.size() == Settings.편인자들.size(): # 모든 편이 다 났다.
			return
		이번윷던질편번호 +=1
		이번윷던질편번호 %= 편들.size()
		if 편들[이번윷던질편번호].난말수얻기() == Settings.편당말수:
			if 난편들.find(편들[이번윷던질편번호]) == -1:
				난편들.append(편들[이번윷던질편번호])
				편들[이번윷던질편번호].등수쓰기(난편들.size())
			continue
		말이동길보이기(편들[이번윷던질편번호])
		윷던지기.modulate = 편들[이번윷던질편번호].인자.색
		윷던지기.text = "%s\n윷던지기" % 편들[이번윷던질편번호]
		break

func 윷던지고말이동하기() -> void:
	if 난편들.size() == Settings.편인자들.size(): # 모든 편이 다 났다.
		return
	윷짝1.윷던지기()
	var 윷던진편 = 편들[이번윷던질편번호]
	var 이동결과 = 윷던진편.새로말달기(윷짝1.결과얻기())
	if not 이동결과.성공:
		이동결과 = 윷던진편.판위의말이동하기(윷짝1.결과얻기())
	if not 이동결과.성공:
		진행사항.text = "%d %s %s 이동할 말이 없습니다.\n" % [윷짝1.던진횟수얻기(), 윷던진편 , 윷짝1 ] + 진행사항.text
		다음편차례준비하기()
		윷던지고말이동하기.call_deferred()
		return
	if 이동결과.말이동과정눈번호.size() == 0:
		다음편차례준비하기()
		윷던지고말이동하기.call_deferred()
		return
	진행사항.text = "%d %s %s\n" % [윷짝1.던진횟수얻기(), 윷던진편 , 윷짝1 ] + 진행사항.text
	if 윷짝1.한번더던지나():
		진행사항.text = "    %s 던저서 한번더 던진다. \n" % [ 윷짝1 ] + 진행사항.text
	var 좌표들 = 눈번호들을좌표로(이동결과.말이동과정눈번호)
	if 이동결과.새로단말 != null:
		좌표들.push_front(윷던진편.길.놓을길시작 )
	if 이동결과.놓을말로돌아간말들.size() != 0:
		진행사항.text = "    %s 놓을말로되돌아갔습니다.\n" % [이동결과.놓을말로돌아간말들 ] + 진행사항.text
		좌표들.push_back(윷던진편.길.놓을길시작 )
	if 이동결과.난말들.size() != 0:
		진행사항.text = "    %s 났습니다.\n" % [이동결과.난말들 ] + 진행사항.text
		좌표들.push_back(윷던진편.길.나는길끝 )
	if 이동결과.잡힌말들.size() != 0 :
		진행사항.text = "    %s 을 잡아 한번더 던진다. \n" % [ 이동결과.잡힌말들 ] + 진행사항.text
	길이동_animation_시작(윷던진편,좌표들,
		func():
			if (not 윷짝1.한번더던지나()) and 이동결과.잡힌말들.size() == 0:
				다음편차례준비하기()
			if Settings.자동진행:
				윷던지고말이동하기.call_deferred()
			)

func _on_윷던지기_pressed() -> void:
	윷던지고말이동하기()

func _on_자동진행_toggled(toggled_on: bool) -> void:
	Settings.자동진행 = toggled_on
	윷던지기.disabled = toggled_on
	if Settings.자동진행:
		윷던지고말이동하기()

func _on_길보기_toggled(toggled_on: bool) -> void:
	Settings.모든길보기 = toggled_on
	말이동길보이기(편들[이번윷던질편번호])

func _on_눈번호보기_toggled(toggled_on: bool) -> void:
	Settings.눈번호보기 = toggled_on
	$"말판/말눈들".눈번호보기(Settings.눈번호보기)

func 눈번호들을좌표로(눈번호들 :Array[int])->Array[Vector2]:
	var 좌표들 :Array[Vector2] = []
	for i in 눈번호들:
		좌표들.append($"말판/말눈들".눈들[i].position )
	return 좌표들

func _on_놀이재시작_pressed() -> void:
	if msma != null:
		msma.stop()
	get_tree().reload_current_scene()

var msma :MultiSectionMoveAnimation
func 길이동_animation_시작(t :편, 이동좌표들 :Array[Vector2], call_at_end_animation :Callable):
	if 이동좌표들.size() <= 1:
		call_at_end_animation.call()
		return
	msma = msma_scene.instantiate()
	$"말판".add_child(msma)
	var r = min(vp_size.x,vp_size.y)/2 *0.9
	var ani용node = 말_scene.instantiate().init(t, r/30, 0 )
	ani용node.position = 이동좌표들[0]
	ani용node.z_index = 4
	msma.add_child(ani용node)
	msma.animation_ended.connect(
		func():
			msma.queue_free.call_deferred()
			call_at_end_animation.call()
			)
	msma.auto_start_with_poslist(ani용node, 이동좌표들, 0.5)
