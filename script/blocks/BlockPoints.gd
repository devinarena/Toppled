extends "res://script/blocks/Block.gd"

var level
export(int) var value = 0


func _ready() -> void:
	level = get_tree().root.get_node("Level")

	var tex = load("res://assets/blocks/points/%s.png" % value)
	$PointsMesh.mesh.material.albedo_texture = tex


func scale(amt: Vector3) -> void:
	.scale(amt)
	$PointsMesh.mesh = $PointsMesh.mesh.duplicate()
	$PointsMesh.mesh.size = amt + Vector3(0.05, 0.05, 0.05)


func pop() -> void:
	level.points += value
	queue_free()


func _on_BlockPoints_body_entered(body: Node) -> void:
	if body.name == "Ground":
		pop()
