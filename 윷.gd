extends Control
class_name 윷

var 결과 :int

func init() -> 윷:
	custom_minimum_size = Vector2(36,64)*2
	$AnimatedSprite2D.position = custom_minimum_size/2
	return self

func 던지기() -> int:
	결과 = randi_range(0,1)
	$AnimatedSprite2D.play("new_animation")
	$Timer.start(0.5)
	return 결과

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 결과
