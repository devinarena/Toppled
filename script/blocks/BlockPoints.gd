extends "res://script/blocks/Block.gd"

class_name BlockPoints

var level
export(int) var value = 0


func _ready() -> void:
	level = get_tree().root.get_node("Level")

	var tex = load("res://assets/blocks/points/%s.png" % value)
	$PointsMesh.mesh = CubeMesh.new()
	$PointsMesh.mesh.size = $Mesh.mesh.size + Vector3(0.05, 0.05, 0.05)
	$PointsMesh.mesh.material = SpatialMaterial.new()
	$PointsMesh.mesh.material.albedo_texture = tex
	$PointsMesh.mesh.material.flags_transparent = true
	$PointsMesh.mesh.material.uv1_scale = Vector3(3, 2, 1)


func scale(amt: Vector3) -> void:
	.scale(amt)
	$PointsMesh.mesh.size = amt + Vector3(0.05, 0.05, 0.05)


func pop() -> void:
	call_deferred("free")
	
	level.award_points(value)


func _on_BlockPoints_body_entered(body: Node) -> void:
	if body.name == "Ground":
		pop()
