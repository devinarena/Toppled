extends "res://script/blocks/Block.gd"

class_name BlockImmovable


func scale(amt: Vector3) -> void:
	.scale(amt)

	if abs(amt.x - 2.0) < 0.001:
		$Mesh.mesh.material.uv1_offset.x = 0
	if abs(amt.y - 2.0) < 0.001:
		$Mesh.mesh.material.uv1_offset.y = 0
	if abs(amt.z - 2.0) < 0.001:
		$Mesh.mesh.material.uv1_offset.z = 0
