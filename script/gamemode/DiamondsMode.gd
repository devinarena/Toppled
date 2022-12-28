extends "res://script/gamemode/GameMode.gd"

class_name DiamondsMode

var total_diamonds: int

func _init(level: Node, one_star_score: int, two_star_score: int, three_star_score: int).(
	level, one_star_score, two_star_score, three_star_score
) -> void:
	self.mode = "diamonds"

	for block in level.get_blocks():
		if block is BlockDiamond:
			total_diamonds += 1


func update_gui(gui: Node) -> void:
	gui.get_node("Control/Toolbar/Tool/Quantity").text = "%s" % self.level.tool_uses
	gui.get_node("Control/LevelInfo/Points").add_color_override("default_color", Color(0.7, 1, 1))
	gui.get_node("Control/LevelInfo/Points").bbcode_text = "[center][img=32x32]res://assets/diamond_icon.png[/img] %s / %s[/center]" % [self.score, self.total_diamonds]


func check_win_condition() -> int:
	var count = 0
	for block in self.level.get_node("Blocks").get_children():
		if block is BlockDiamond:
			count += 1

	if count <= 1:
		return 1

	return -1
