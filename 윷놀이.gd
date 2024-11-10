extends Node2D

const 편인자들 = [
	["빨강색", Color.RED, 3],
	["초록색", Color.GREEN, 4],
	["하늘색", Color.SKY_BLUE, 5],
	["노랑색", Color.YELLOW, 6],
]
const 편당말수 = 4

@onready var 편통 = $"VBoxContainer2/편들상태/VBoxContainer2/VBoxContainer"
@onready var 진행사항 = $"VBoxContainer/ScrollContainer/진행사항"
@onready var 윷던지기 = $"VBoxContainer2/윷던지기"
@onready var 윷짝1 = $"VBoxContainer2/윷짝"

var 편_scene = preload("res://편.tscn")
var msma_scene = preload("res://multi_section_move_animation/multi_section_move_animation.tscn")
var 말_scene = preload("res://말.tscn")

var 편들 :Array[편]
var vp_size
func init() -> void:
	vp_size = get_viewport_rect().size
	var r = min(vp_size.x,vp_size.y)/2 *0.9

	$"말눈들".init(r,Color.GRAY)
	$"말눈들".position = vp_size/2
	윷짝1.init()
	$VBoxContainer.size = Vector2(vp_size.x/2 -r*1.1, vp_size.y)
	$VBoxContainer2.size = Vector2(vp_size.x/2 -r*1.1, vp_size.y)
	$VBoxContainer2.position = Vector2(vp_size.x/2 + r*1.1, 0)

	# 편 가르기
	for ti in 편인자들:
		var t = 편_scene.instantiate()
		편통.add_child(t)
		var 시작눈 = 말이동길.가능한시작눈목록.pick_random()
		var mirror = randi_range(0,1)==0
		t.init(ti, 편당말수, r, $"말눈들", 시작눈, mirror)
		#print(t.길)
		편들.append(t)
		t.길.position = vp_size/2
		add_child(t.길)

		t.길단추.pressed.connect(
			func():
				self.말이동길보이기(t)
				)

	말이동길보이기(편들[0])
	윷던지기.modulate = 편들[0].편색
	윷던지기.text = "%s편\n윷던지기" % 편들[0].편이름

func _ready() -> void:
	init()

func 말이동길보이기(t:편) ->void:
	if 모든길보기:
		말이동길모두보기()
	else:
		for i in 편들:
			i.길.visible = false
		t.길.visible = true
		t.길.position = vp_size/2

func 말이동길모두보기() ->void:
	var deg_start = 30.0
	var deg_inc = 360.0 / 편들.size()
	var r = min(vp_size.x,vp_size.y)/2 * 0.03
	var i = 0
	for t in 편들:
		t.길.visible = true
		var ra = deg_to_rad( deg_start + i*deg_inc)
		t.길.position = vp_size/2 + PolygonNode.make_pos_by_rad_r(ra,r)
		i+=1

var 이번윷던질편번호 =0
var 난편들 :Array[편]
func 다음편차례준비하기():
	while true:
		if 난편들.size() == 편인자들.size(): # 모든 편이 다 났다.
			return
		이번윷던질편번호 +=1
		이번윷던질편번호 %= 편들.size()
		if 편들[이번윷던질편번호].난말수얻기() == 편당말수:
			if 난편들.find(편들[이번윷던질편번호]) == -1:
				난편들.append(편들[이번윷던질편번호])
				편들[이번윷던질편번호].등수쓰기(난편들.size())
			continue
		말이동길보이기(편들[이번윷던질편번호])
		윷던지기.modulate = 편들[이번윷던질편번호].편색
		윷던지기.text = "%s편\n윷던지기" % 편들[이번윷던질편번호].편이름
		break
	if 자동진행:
		윷던지고말이동하기.call_deferred()

func 윷던지고말이동하기() -> void:
	if 난편들.size() == 편인자들.size(): # 모든 편이 다 났다.
		return
	윷짝1.윷던지기()
	var 결과 = 윷짝1.결과얻기()
	var 윷던진편 = 편들[이번윷던질편번호]
	var 이동결과 = 윷던진편.새로말달기(결과)
	if 이동결과.is_empty():
		이동결과 = 윷던진편.판위의말이동하기(결과)
	if 이동결과.is_empty():
		진행사항.text = "%d %s편 %s 이동할 말이 없습니다.\n" % [윷짝1.던진횟수얻기(), 윷던진편.편이름 , 윷짝1 ] + 진행사항.text
		다음편차례준비하기()
		return
	var 말이동과정눈번호 = 이동결과.get("말이동과정눈번호",[])
	if 말이동과정눈번호.size() == 0:
		다음편차례준비하기()
		return
	var 잡힌말들 = 이동결과.get("잡힌말들",[])
	var 난말들 = 이동결과.get("난말들",[])
	var 놓을말로돌아간말들 = 이동결과.get("놓을말로돌아간말들",[])
	var 새로단말 = 이동결과.get("새로단말",null)
	진행사항.text = "%d %s편 %s\n" % [윷짝1.던진횟수얻기(), 윷던진편.편이름 , 윷짝1 ] + 진행사항.text
	if 윷짝1.한번더던지나(결과):
		진행사항.text = "    %s 던저서 한번더 던진다. \n" % [ 윷짝1 ] + 진행사항.text
	var 좌표들 = 눈번호들을좌표로(말이동과정눈번호)
	if 새로단말 != null:
		좌표들.push_front(윷던진편.길.놓을길시작 )
	if 놓을말로돌아간말들.size() != 0:
		진행사항.text = "    %s 놓을말로되돌아갔습니다.\n" % [놓을말로돌아간말들 ] + 진행사항.text
		좌표들.push_back(윷던진편.길.놓을길시작 )
	if 난말들.size() != 0:
		진행사항.text = "    %s 났습니다.\n" % [난말들 ] + 진행사항.text
		좌표들.push_back(윷던진편.길.나는길끝 )
	if 잡힌말들.size() != 0 :
		진행사항.text = "    %s 을 잡아 한번더 던진다. \n" % [ 잡힌말들 ] + 진행사항.text
	길이동_animation_시작(윷던진편,좌표들 )

	if (not 윷짝1.한번더던지나(결과)) and 잡힌말들.size() == 0 :
		다음편차례준비하기()
	if 자동진행:
		윷던지고말이동하기.call_deferred()

func _on_윷던지기_pressed() -> void:
	윷던지고말이동하기()

var 자동진행 :bool
func _on_자동진행_toggled(toggled_on: bool) -> void:
	자동진행 = toggled_on
	if 자동진행:
		윷던지고말이동하기()

var 모든길보기 :bool
func _on_길보기_toggled(toggled_on: bool) -> void:
	모든길보기 = toggled_on
	말이동길보이기(편들[이번윷던질편번호])

func 눈번호들을좌표로(눈번호들 :Array[int])->Array[Vector2]:
	var 좌표들 :Array[Vector2] = []
	for i in 눈번호들:
		좌표들.append($"말눈들".눈들[i].position )
	return 좌표들

func _on_놀이재시작_pressed() -> void:
	get_tree().reload_current_scene()

func _on_눈번호보기_toggled(toggled_on: bool) -> void:
	$"말눈들".눈번호보기(toggled_on)

func 길이동_animation_시작(t :편, 이동좌표들 :Array[Vector2]):
	if 이동좌표들.size() <= 1:
		길이동_animation_종료(null)
		return

	var msma = msma_scene.instantiate()
	add_child(msma)
	msma.position = vp_size/2

	var r = min(vp_size.x,vp_size.y)/2 *0.9
	var ani용node = 말_scene.instantiate().init(t, r/30, 0, 8 )
	msma.add_child(ani용node)

	msma.animation_ended.connect(길이동_animation_종료)
	msma.auto_start_with_poslist(ani용node, 이동좌표들, 0.5)

func 길이동_animation_종료(msma: MultiSectionMoveAnimation):
	if msma != null:
		msma.queue_free.call_deferred()
