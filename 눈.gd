extends Node2D

class_name 눈

var 다음눈 :눈
var 지름길눈 :눈 # 지름길이 없으면 비어 있음.

func init(r :float, co: Color, 번호:int) -> void:
	$ColorRect.color = co
	$ColorRect.size = Vector2(r,r)*2
	$Label.text = "%d" % 번호

func _ready() -> void:
	pass
