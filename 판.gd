extends Node2D

var 눈_scene = preload("res://눈.tscn")

var r :float
var co :Color
var 화살표선들 :PackedVector2Array =[]


func init(r: float, co :Color) -> void:
	self.r = r
	self.co = co
	for i in range(0,360,360/20):
		var rd = deg_to_rad(i)
		var pos = make_pos_by_rad_r(rd,r)
		눈추가(r,pos,co)

	for i in [-0.33,-0.66,0.33,0.66]:
		눈추가(r,Vector2(r*i,0),co)
		눈추가(r,Vector2(0,r*i),co)

	눈추가(r,Vector2(0,0),co)

	for i in range(0,360,360/20):
		var rd1 = deg_to_rad(i)
		var rd2 = deg_to_rad(i+360/20)
		화살표선들.append_array([make_pos_by_rad_r(rd1,r),make_pos_by_rad_r(rd2,r)])
	for i in [-1.0,-0.33,-0.66,0,0.33,0.66]:
		화살표선들.append_array([Vector2(r*i,0),Vector2(r*(i+0.33),0)])
		화살표선들.append_array([Vector2(0,r*i),Vector2(0,r*(i+0.33))])

func 눈추가(r: float, pos:Vector2,co:Color):
	var 눈1 = 눈_scene.instantiate()
	눈1.init(r/30, co)
	눈1.position = pos
	add_child(눈1)

func _draw() -> void:
	draw_multiline(화살표선들,co, 1)


func _ready() -> void:
	pass

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)
