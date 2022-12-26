extends RigidBody

class_name ToppleTool

export(float) var throw_strength = 1.0

var initial_velocity: Vector3
var level


func _ready():
	level = get_tree().root.get_node("Level")


func _integrate_forces(state) -> void:
	if not state.linear_velocity:
		apply_central_impulse(initial_velocity * mass * throw_strength)
		initial_velocity = Vector3.ZERO


func _on_KillTimer_timeout() -> void:
	call_deferred("free")
