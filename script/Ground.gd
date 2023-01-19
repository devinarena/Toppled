extends RigidBody

var level


func _ready():
	if get_tree().root.has_node("Level"):
		level = get_tree().root.get_node("Level")


func _on_Ground_body_entered(body: Node):
	if body is Block:
		if level:
			level.gamemode.block_hit_ground(body)
		elif body is BlockPoints or body is BlockDiamond:
			body.pop()
