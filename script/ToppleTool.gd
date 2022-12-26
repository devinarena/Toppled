extends RigidBody

class_name ToppleTool

var initial_velocity: Vector3

func _ready():
	pass

func _integrate_forces(state) -> void:
	if not state.linear_velocity:
		apply_central_impulse(initial_velocity * mass)
		initial_velocity = Vector3.ZERO

func _on_KillTimer_timeout() -> void:
	call_deferred("free")
