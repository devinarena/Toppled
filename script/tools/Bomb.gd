extends "res://script/ToppleTool.gd"

const EXPLOSION_RADIUS: float = 18.0
const EXPLOSION_FORCE: float = 0.35


func explode() -> void:
	call_deferred("free")
	var blocks = level.get_blocks()

	for block in blocks:
		var distance = block.global_transform.origin.distance_squared_to(global_transform.origin)
		if distance < EXPLOSION_RADIUS * EXPLOSION_RADIUS:
			var force = (EXPLOSION_RADIUS * EXPLOSION_RADIUS) / distance
			var dir = (block.global_transform.origin - global_transform.origin).normalized()

			block.apply_impulse(
				Vector3(
					(randi() % 2) * 2 - 1 - (randf() * 0.4 + 0.1),
					(randi() % 2) * 2 - 1 - (randf() * 0.4 + 0.1),
					(randi() % 2) * 2 - 1 - (randf() * 0.4 + 0.1)
				),
				dir * force * EXPLOSION_FORCE * pow(block.mass, 0.65)
			)

			block.explode()


func _on_Bomb_body_entered(body: Node) -> void:
	explode()
