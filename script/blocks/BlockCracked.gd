extends "res://script/blocks/Block.gd"

var dead = false


func pop() -> void:
	dead = true


func _physics_process(delta):
	if dead:
		translate(Vector3.DOWN * 100 * delta)
		call_deferred("free")


func _on_BlockCracked_body_entered(body: Node):
	if body is ToppleTool:
		pop()
