extends "res://script/gamemode/GameMode.gd"

class_name PointsMode


func _init(level: Node, one_star_score: int, two_star_score: int, three_star_score: int).(
	level, one_star_score, two_star_score, three_star_score
) -> void:
	self.mode = "points"


func update_gui(gui: Node) -> void:
	gui.get_node("Control/Toolbar/Tool/Quantity").text = "%s" % self.level.tool_uses
	gui.get_node("Control/LevelInfo/Points").text = "%s" % self.score


func check_win_condition() -> int:
	var count = 0
	for block in self.level.get_node("Blocks").get_children():
		if block is BlockPoints:
			count += 1

	if count <= 1:
		return 1

	return -1
