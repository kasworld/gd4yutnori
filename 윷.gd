extends Control
class_name 윷

const ANI_SEC = 0.5
var ani_start :float
var 결과 :int

func init() -> 윷:
	custom_minimum_size = Vector2(36,64)*2
	$"배면".position = custom_minimum_size/2
	$"등면".position = custom_minimum_size/2
	return self

func 던지기() -> int:
	결과 = randi_range(0,1)
	결과표시()
	ani_start = Time.get_unix_time_from_system()
	return 결과

func 결과표시():
	$"배면".visible = 결과 == 1
	$"등면".visible = 결과 == 0

func _process(delta: float) -> void:
	var dur = Time.get_unix_time_from_system() - ani_start
	if dur > ANI_SEC:
		결과표시()
		return
	$"배면".visible = not $"배면".visible
	$"등면".visible = not $"등면".visible
