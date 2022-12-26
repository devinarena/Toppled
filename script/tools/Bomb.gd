extends "res://script/ToppleTool.gd"

const EXPLOSION_RADIUS: float = 96.0
const EXPLOSION_FORCE: float = 0.0004


func explode() -> void:
	call_deferred("free")
	var blocks = level.get_blocks()

	for block in blocks:
		var distance = block.global_transform.origin.distance_squared_to(global_transform.origin)
		if distance < EXPLOSION_RADIUS * EXPLOSION_RADIUS:
			var force = EXPLOSION_RADIUS * EXPLOSION_RADIUS - distance
			var dir = (block.global_transform.origin - global_transform.origin).normalized()

			block.apply_impulse(
				Vector3(
					(1 * randf() - 0.5) * block.scale.x,
					(1 * randf() - 0.5) * block.scale.y,
					(1 * randf() - 0.5) * block.scale.z
				),
				dir * max(force * EXPLOSION_FORCE, 3.0)
			)

			block.explode()


func _on_Bomb_body_entered(body: Node) -> void:
	explode()
