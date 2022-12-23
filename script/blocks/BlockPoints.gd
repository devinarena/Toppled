extends RigidBody

var value = 0

func _ready() -> void:
	var tex = load("res://assets/blocks/points/%s.png" % value)
	$PointsMesh.mesh.material.albedo_texture = tex


func _on_BlockPoints_body_entered(body:Node) -> void:
	print(body.name)
