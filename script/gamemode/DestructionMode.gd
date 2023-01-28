extends "res://script/gamemode/GameMode.gd"

class_name DestructionMode

var total_mass: float
var initial_total_mass: float


func _init(level: Node, one_star_score: int, two_star_score: int, three_star_score: int).(
	level, one_star_score, two_star_score, three_star_score
) -> void:
	self.mode = "destruction"
	self.text_color = Globals.level_type_data[self.mode].text_color

	for block in level.get_blocks():
		if not block is BlockImmovable:
			total_mass += block.mass
			block.connect("pop", self, "_on_block_pop", [block])

	initial_total_mass = total_mass

	var s_con = level.get_node("GUI/Control/Dialog/CenterContainer/VBoxContainer/HBoxContainer")
	s_con.get_node("StarOne/Score").add_color_override("default_color", self.text_color)
	s_con.get_node("StarOne/Score").bbcode_text = "[center]%s%%[/center]" % self.one_star_score
	s_con.get_node("StarTwo/Score").add_color_override("default_color", self.text_color)
	s_con.get_node("StarTwo/Score").bbcode_text = "[center]%s%%[/center]" % self.two_star_score
	s_con.get_node("StarThree/Score").add_color_override("default_color", self.text_color)
	s_con.get_node("StarThree/Score").bbcode_text = "[center]%s%%[/center]" % self.three_star_score


func update_gui(gui: Node) -> void:
	gui.get_node("Control/Toolbar/Tool/Quantity").text = "%s" % self.level.tool_uses
	gui.get_node("Control/LevelInfo/Points").add_color_override("default_color", self.text_color)
	gui.get_node("Control/LevelInfo/Points").bbcode_text = ("[center]%s%%[/center]" % [score])


func check_win_condition() -> int:
	var count = 0
	for block in self.level.get_node("Blocks").get_children():
		if not block is BlockImmovable:
			count += 1

	if count <= 1:
		return 1

	return -1


func _on_block_pop(block: Block) -> void:
	level.award_points(0)
	total_mass -= block.mass

	score = ceil((1 - total_mass / initial_total_mass) * 100.0)


func block_hit_ground(block: Block) -> void:
	if not block is BlockImmovable:
		block.pop()

		reset_end_timer()
