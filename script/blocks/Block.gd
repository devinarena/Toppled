extends RigidBody

const DEFAULT_MASS: float = 1.0

func _ready():
	var volume = abs($Mesh.mesh.size.x * $Mesh.mesh.size.y * $Mesh.mesh.size.z)
	mass = DEFAULT_MASS * volume
	
func scale(amt: Vector3) -> void:
	$Mesh.mesh = $Mesh.mesh.duplicate()
	$Mesh.mesh.size = amt
	$CollisionShape.shape = BoxShape.new()
	$CollisionShape.shape.extents = amt / 2
		
