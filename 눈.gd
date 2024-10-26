extends Node2D

func init(r :float, co: Color) -> void:
	$ColorRect.color = co
	$ColorRect.size = Vector2(r,r)*2

func _ready() -> void:
	pass
