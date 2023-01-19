extends "res://script/blocks/Block.gd"

class_name BlockDiamond

var level


func _ready() -> void:
	if get_tree().root.has_node("Level"):
		level = get_tree().root.get_node("Level")


func pop() -> void:
	.pop()
	if level:
		level.award_points(1)