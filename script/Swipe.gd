extends Node

signal swipe
const STRENGTH: float =  0.005
var swipe_start: float = 0.0
var start_time: float = 0.0


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			swipe_start = event.position.y
			start_time = OS.get_ticks_msec()
		else:
			_calculate_swipe(event.position)
	if event is InputEventMouseMotion:
		if abs(event.position.y - swipe_start) < 64:
			start_time = OS.get_ticks_msec()


func _calculate_swipe(swipe_end: Vector2):
	if not swipe_start:
		return
	
	var swipe = swipe_start - swipe_end.y
	var swipe_time = max(0.05, (OS.get_ticks_msec() - start_time) / 1000.0)
	emit_signal("swipe", swipe_end, swipe * STRENGTH / swipe_time)
	swipe_start = 0.0
