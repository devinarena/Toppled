extends RigidBody

class_name Block

const DEFAULT_MASS: float = 1.0


func _ready():
	var volume = abs($Mesh.mesh.size.x * $Mesh.mesh.size.y * $Mesh.mesh.size.z)
	mass = DEFAULT_MASS * volume


func _physics_process(delta):
	var ray = get_world().direct_space_state.intersect_ray(
		global_transform.origin, global_transform.origin + Vector3(0, -1, 0)
	)

	if not ray:
		# apply gravity
		apply_central_impulse(Vector3(0, -0.001, 0))


func scale(amt: Vector3) -> void:
	$Mesh.mesh = $Mesh.mesh.duplicate()
	$Mesh.mesh.size = amt
	$CollisionShape.shape = BoxShape.new()
	$CollisionShape.shape.extents = amt / 2 - Vector3(0.015, 0.015, 0.015)

	var volume = abs($Mesh.mesh.size.x * $Mesh.mesh.size.y * $Mesh.mesh.size.z)
	mass = DEFAULT_MASS * volume
