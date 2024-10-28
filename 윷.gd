extends Control
class_name 윷

func init() -> 윷:
	custom_minimum_size = Vector2(36,64)*2
	return self

func 던지기() -> int:
	var rtn = randi_range(0,1)
	$"배면".visible = rtn == 1
	$"등면".visible = rtn == 0
	return rtn

func _ready() -> void:
	pass
