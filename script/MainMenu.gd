extends Node

const s_points_mode = "res://scenes/PointsLevelMenu.tscn"

func _on_PointsMode_pressed():
	get_tree().change_scene(s_points_mode)
