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

	$"말눈들".init(r,Color.WHITE)
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
	if 난편들.size() == 편인자들.size(): # 모든 편이 다 났다.
		return
	while true:
		if 난편들.size() == 편인자들.size(): # 모든 편이 다 났다.
			print(난편들)
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

var 윷던진횟수 = 0
func 윷던지고말이동하기() -> void:
	if 난편들.size() == 편인자들.size(): # 모든 편이 다 났다.
		return
	윷짝1.윷던지기()
	윷던진횟수 += 1
	var 결과 = 윷짝1.결과얻기()
	var 이동결과 = 편들[이번윷던질편번호].새로말달기(결과)
	if 이동결과.is_empty():
		이동결과 = 편들[이번윷던질편번호].판위의말이동하기(결과)
	if 이동결과.is_empty():
		다음편차례준비하기()
		return
	var 말이동과정눈번호 = 이동결과.get("말이동과정눈번호",[])
	if 말이동과정눈번호.size() != 0:
		길이동_animation(편들[이번윷던질편번호],말이동과정눈번호 )

	var 잡은말들 = 이동결과.get("잡은말들",[])
	var 난말들 = 이동결과.get("난말들",[])
	진행사항.text = "%d %s편 %s\n" % [윷던진횟수, 편들[이번윷던질편번호].편이름 , 윷짝1 ] + 진행사항.text
	if 난말들.size() != 0:
		진행사항.text = "    %s 났습니다.\n" % [난말들 ] + 진행사항.text
	if (not 윷짝1.한번더던지나(결과)) and 잡은말들.size() == 0 :
		다음편차례준비하기()
	else:
		if 잡은말들.size() != 0 :
			진행사항.text = "    %s 을 잡아 한번더 던진다. \n" % [ 잡은말들 ] + 진행사항.text
		else:
			진행사항.text = "    %s 던저서 한번더 던진다. \n" % [ 윷짝1 ] + 진행사항.text

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

func 길이동_animation(t :편, 이동과정 :Array[int]):
	if 이동과정.size() <= 1:
		#print("이동과정을 생략합니다. ",이동과정)
		return

	var 이동좌표들  :Array[Vector2] = []
	for i in 이동과정:
		이동좌표들.append(t.길.눈들[i].position )
	var msma = msma_scene.instantiate()
	add_child(msma)
	msma.position = vp_size/2

	var r = min(vp_size.x,vp_size.y)/2 *0.9
	var ani용말 = 말_scene.instantiate().init(t, r/30, 0, 8 )
	msma.add_child(ani용말)

	msma.animation_ended.connect(길이동_animation_종료)
	msma.auto_start_with_poslist(ani용말, 이동좌표들,0.5)

func 길이동_animation_종료(msma: MultiSectionMoveAnimation):
	msma.queue_free.call_deferred()

func _on_놀이재시작_pressed() -> void:
	get_tree().reload_current_scene()

func _on_눈번호보기_toggled(toggled_on: bool) -> void:
	$"말눈들".눈번호보기(toggled_on)
