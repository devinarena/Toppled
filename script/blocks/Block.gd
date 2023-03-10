extends RigidBody

const pbreak = preload("res://scenes/particles/ParticlesBreak.tscn")

class_name Block

const DEFAULT_MASS: float = 1.0

signal pop


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


func explode() -> void:
	pass


func pop() -> void:
	var particles = pbreak.instance()
	particles.global_transform = global_transform
	particles.material_override = $Mesh.mesh.material.duplicate()
	particles.material_override.params_billboard_mode = SpatialMaterial.BILLBOARD_PARTICLES
	particles.scale = $Mesh.mesh.size

	if get_tree().root.has_node("Level"):
		get_tree().root.get_node("Level").add_child(particles)
	else:
		for child in get_tree().root.get_children():
			if "LevelMenu" in child.name:
				child.add_child(particles)
				break

	emit_signal("pop")
	call_deferred("free")


func scale(amt: Vector3) -> void:
	$Mesh.mesh = $Mesh.mesh.duplicate()
	$Mesh.mesh.size = amt
	$CollisionShape.shape = BoxShape.new()
	$CollisionShape.shape.extents = amt / 2

	var volume = abs($Mesh.mesh.size.x * $Mesh.mesh.size.y * $Mesh.mesh.size.z)
	mass = DEFAULT_MASS * volume
