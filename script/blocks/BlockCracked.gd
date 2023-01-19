extends "res://script/blocks/Block.gd"

class_name BlockCracked


func explode() -> void:
	pop()


func _on_BlockCracked_body_entered(body: Node):
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	if body is ToppleTool:
		pop()
