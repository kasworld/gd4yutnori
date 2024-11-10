extends Node2D
class_name MultiSectionMoveAnimation

signal animation_ended()

var enabled = false
var current_animation_section = 0
var section_begin_tick = 0
var second_per_animation_section = 1.0
var remain_animation_section :int

var move_node :Node # node2d
var pos_list :Array # of vector2

func auto_start_with_poslist(o :Node, pl :Array,section_dur :float = 1 ):
	move_node = o
	pos_list = pl
	start_with_limit_animation_section(pl.size()-1, section_dur)

func _process(_delta: float) -> void:
	if not enabled:
		return
	var r = rate_in_section()
	move_position(move_node, pos_list, r)

func toggle()->void:
	if enabled:
		stop()
	else:
		start(second_per_animation_section)

# repeat inf
func start(section_dur :float = 1)->void:
	second_per_animation_section = section_dur
	enabled = true
	section_begin_tick = Time.get_unix_time_from_system()
	$Timer.start(second_per_animation_section)

# auto stop after animation_section number
func start_with_limit_animation_section(limit_animation_section :int, section_dur :float = 1)->void:
	remain_animation_section = limit_animation_section
	start(section_dur)

func stop()->void:
	enabled = false
	$Timer.stop()
	animation_ended.emit()

func _on_timer_timeout() -> void:
	current_animation_section += 1
	section_begin_tick = Time.get_unix_time_from_system()
	if remain_animation_section > 0 :
		remain_animation_section -= 1
		if remain_animation_section <= 0:
			stop()

# v1,v2 : + - , * with float
# return type of v1,v2
func calc_inter(v1 , v2 , rate :float):
	return (cos(rate *PI)/2 +0.5) * (v1-v2) + v2

# o :position , p1,p2 : + - , * with float
func move_by_ms(o , p1 , p2 , rate:float)->void:
	o.position = calc_inter(p1,p2,rate)

# o :position, pos_list[n] : + - , * with float
func move_position(o , plist :Array, rate :float)->void:
	var l = plist.size()
	var p1 = plist[current_animation_section%l]
	var p2 = plist[(current_animation_section+1)%l]
	o.position = calc_inter(p1,p2,rate)

func rate_in_section()->float:
	return (Time.get_unix_time_from_system() - section_begin_tick)/second_per_animation_section
