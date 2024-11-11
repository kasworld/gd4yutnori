extends PanelContainer
class_name 편

class 인자틀:
	var 이름 :String
	var 색 :Color
	var 모양 :int
	var 크기보정 :float
	func _init(a,b,c,d) -> void:
		이름 = a
		색 = b
		모양 = c
		크기보정 = d


@onready var 놓을말통 = $HBoxContainer/HBoxContainer
@onready var 난말통 = $HBoxContainer/HBoxContainer2
@onready var 길단추 = $HBoxContainer/Button

var 말_scene = preload("res://말.tscn")
var 말이동길_scene = preload("res://말이동길.tscn")

var 인자 :인자틀
var 눈들 :말눈들
var 길 :말이동길
var 말들 :Array[말]
func _to_string() -> String:
	return "%s편" % [인자.이름]

func init(편정보 :인자틀, 말수 :int, 크기:float, es :말눈들, 시작눈 :int, mirror :bool = false) -> void:
	인자 = 편정보
	눈들 = es
	길 = 말이동길_scene.instantiate()
	길.init( max(1,크기/200), 인자.색, es.눈들, 시작눈, mirror)
	var r = 크기/30
	custom_minimum_size = Vector2(r*2*10,r*2)
	놓을말통.custom_minimum_size = Vector2(r*2*4,r*2)
	난말통.custom_minimum_size = Vector2(r*2*4,r*2)
	길단추.text = 인자.이름
	길단추.modulate = 인자.색
	for i in range(0,말수):
		var m = 말_scene.instantiate().init(self, r, i+1)
		놓을말통.add_child(m)
		말들.append(m)

func 놓을말로되돌리기(ms :Array[말]):
	for m in ms:
		m.지나온눈들.clear()
		m.편얻기().놓을말통.add_child(m)

func 난말로넣기(ms :Array[말]):
	for m in ms:
		m.편얻기().난말통.add_child(m)

func 난말수얻기() -> int:
	return 난말통.get_child_count()

func 놓을말얻기()->말:
	if 놓을말통.get_child_count() == 0:
		return null
	var m = 놓을말통.get_child(0)
	놓을말통.remove_child(m)
	return m

func 등수쓰기(n :int):
	$HBoxContainer/Label.text = "%d등" % n

# 업은경우가 있어 말들을 돌려준다.
func 판위말고르기()->Array[말]:
	for m in 말들:
		if m.지나온눈들.size() != 0 and m.지나온눈들[-1].번호 != 길.종점눈번호() and m.지나온눈들[-1].말보기().size() != 0 : # 업힌말 인경우 처리
			return m.지나온눈들[-1].말보기()
	return []

class 이동결과틀:
	var 말이동과정눈번호 :Array[int]
	var 잡힌말들 :Array[말]
	var 새로단말 :말
	var 놓을말로돌아간말들 :Array[말]
	var 난말들 :Array[말]
	var 성공 :bool

func 새로말달기(이동거리 :int)->이동결과틀:
	var 결과 = 이동결과틀.new()
	if 이동거리<=0:
		return 결과
	var m = 놓을말얻기()
	if m == null:
		return 결과
	결과.말이동과정눈번호 = 길.말이동과정찾기(-1,이동거리)
	for i in 결과.말이동과정눈번호:
		m.지나온눈들.append(눈들.눈얻기(i))
	var 도착눈 = 눈들.눈얻기(결과.말이동과정눈번호[-1])
	결과.잡힌말들 = 도착눈.말놓기([m])
	놓을말로되돌리기(결과.잡힌말들)
	결과.새로단말 = m
	결과.성공 = true
	return 결과

func 판위의말이동하기(이동거리 :int)->이동결과틀:
	var 결과 = 이동결과틀.new()
	var ms = 판위말고르기()
	if ms.size() == 0: # 말없음
		return 결과
	if 이동거리 == 0:
		print("잘못된이동거리 ", 이동거리)
		return 결과
	if 이동거리 < 0: # 뒷도개걸 처리
		ms = ms[0].지나온눈들[-1].말빼기() # 눈에서 제거한다.
		if ms[0].지나온눈들.size() <= -이동거리: #판에서 빼서 놓을 말로 돌아간다.
			for i in ms[0].지나온눈들:
				결과.말이동과정눈번호.append(i.번호)
			결과.말이동과정눈번호.reverse()
			놓을말로되돌리기(ms)
			결과.놓을말로돌아간말들 = ms
			결과.성공 = true
			return 결과
		for i in range(이동거리,0): # 업은말의 첫말의 지나온눈들에서 빼면서 뒤로 이동한다.
			결과.말이동과정눈번호.append(ms[0].지나온눈들.pop_back().번호)
		결과.말이동과정눈번호.append(ms[0].지나온눈들[-1].번호)
		결과.잡힌말들 = ms[0].지나온눈들[-1].말놓기(ms)
		놓을말로되돌리기(결과.잡힌말들)
		결과.성공 = true
		return 결과

	# 앞으로 가기
	var 기존위치눈번호 = ms[0].지나온눈들[-1].번호
	결과.말이동과정눈번호 = 길.말이동과정찾기(ms[0].지나온눈들[-1].번호,이동거리)
	if 결과.말이동과정눈번호.size() == 0:
		print("말이동과정찾기 실패 ",ms,결과.말이동과정눈번호)
		return 결과
	ms = ms[0].지나온눈들[-1].말빼기() # 눈에서 제거한다.
	for i in 결과.말이동과정눈번호: # 말에 지나가는 눈들 추가
		ms[0].지나온눈들.append(눈들.눈얻기(i))
	결과.말이동과정눈번호.push_front(기존위치눈번호)
	if 결과.말이동과정눈번호[-1] == 길.종점눈번호(): # 말이 났다.
		난말로넣기(ms)
		결과.난말들 = ms
		결과.성공 = true
		return 결과
	var 도착눈 = 눈들.눈얻기(결과.말이동과정눈번호[-1])
	결과.잡힌말들 = 도착눈.말놓기(ms)
	놓을말로되돌리기(결과.잡힌말들)
	결과.성공 = true
	return 결과
