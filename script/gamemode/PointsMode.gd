extends "res://script/gamemode/GameMode.gd"

class_name PointsMode


func _init(level: Node, one_star_score: int, two_star_score: int, three_star_score: int).(
	level, one_star_score, two_star_score, three_star_score
) -> void:
	self.mode = "points"
	self.text_color = Globals.level_type_data[self.mode].text_color

	var s_con = level.get_node("GUI/Control/Dialog/CenterContainer/VBoxContainer/HBoxContainer")
	s_con.get_node("StarOne/Score").add_color_override("default_color", self.text_color)
	s_con.get_node("StarOne/Score").bbcode_text = "[center]%s[/center]" % self.one_star_score
	s_con.get_node("StarTwo/Score").add_color_override("default_color", self.text_color)
	s_con.get_node("StarTwo/Score").bbcode_text = "[center]%s[/center]" % self.two_star_score
	s_con.get_node("StarThree/Score").add_color_override("default_color", self.text_color)
	s_con.get_node("StarThree/Score").bbcode_text = "[center]%s[/center]" % self.three_star_score


func update_gui(gui: Node) -> void:
	gui.get_node("Control/Toolbar/Tool/Quantity").text = "%s" % self.level.tool_uses
	gui.get_node("Control/LevelInfo/Points").add_color_override("default_color", self.text_color)
	gui.get_node("Control/LevelInfo/Points").bbcode_text = "[center]%s[/center]" % self.score


func check_win_condition() -> int:
	var count = 0
	for block in self.level.get_node("Blocks").get_children():
		if block is BlockPoints:
			count += 1

	if count <= 1:
		return 1

	return -1


func block_hit_ground(block: Block) -> void:
	if block is BlockPoints:
		block.pop()
