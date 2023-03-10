extends Node

const s_points_mode = "res://scenes/PointsLevelMenu.tscn"
const s_diamonds_mode = "res://scenes/DiamondsLevelMenu.tscn"
const s_destr_mode = "res://scenes/DestructionLevelMenu.tscn"


func _on_PointsMode_pressed() -> void:
	get_tree().change_scene(s_points_mode)


func _on_Diamonds_pressed() -> void:
	get_tree().change_scene(s_diamonds_mode)


func _on_DestructionMode_pressed() -> void:
	get_tree().change_scene(s_destr_mode)
