extends Node2D
class_name 눈

var 번호 :int
func init(r :float, co: Color, 번호:int) -> void:
	self.번호 = 번호
	$ColorRect.color = co
	$ColorRect.size = Vector2(r,r)*2
	$Label.text = "%d" % 번호

func _ready() -> void:
	pass
