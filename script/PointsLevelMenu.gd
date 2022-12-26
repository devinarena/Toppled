extends Node

const s_level = "res://scenes/Level.tscn"

var level_idx: int = 0
var levels: Array = []
var timer: float = 0.0

var level_stats = {
	"DoubleStack":
	{
		"total_blocks": 8,
		"point_blocks": 2,
		"block_mass": 144,
		"tool": {"type": "bowlingball", "quantity": 4}
	},
	"Floating":
	{
		"total_blocks": 10,
		"point_blocks": 5,
		"block_mass": 10,
		"tool": {"type": "baseball", "quantity": 5}
	},
	"Floodgate":
	{
		"total_blocks": 11,
		"point_blocks": 6,
		"block_mass": 379,
		"tool": {"type": "baseball", "quantity": 1}
	},
	"Insides":
	{
		"total_blocks": 125,
		"point_blocks": 27,
		"block_mass": 125,
		"tool": {"type": "bomb", "quantity": 2}
	},
}


func load_levels() -> void:
	var dir = Directory.new()
	if dir.open("res://levels") == OK:
		dir.list_dir_begin()
		var level = dir.get_next()
		while level:
			if level == ".." or level == ".":
				level = dir.get_next()
				continue

			level = level.split(".")[0]
			var lname = ""
			var first = true
			for c in level:
				if c == c.to_upper() and not first:
					lname += " " + c
				else:
					lname += c
				first = false

			levels.push_back([lname, level])

			level = dir.get_next()


func setup_gui() -> void:
	var level = levels[level_idx]
	$Control/LevelName.text = level[0]

	if not level[1] in level_stats:
		return

	var stats = level_stats[level[1]]

	$Control/LevelStats/TotalBlocks.bbcode_text = (
		"[img=32x32]res://assets/blocks/normal.png[/img]x%s blocks"
		% stats.total_blocks
	)
	$Control/LevelStats/TotalPointBlocks.bbcode_text = (
		"[img=32x32]res://assets/blocks/point_base.png[/img]x%s blocks"
		% stats.point_blocks
	)
	$Control/LevelStats/BlockMass.bbcode_text = (
		"[img=32x32]res://assets/blocks/normal.png[/img]x%s kg"
		% stats.block_mass
	)
	$Control/LevelStats/ToolUses.bbcode_text = (
		"[img=32x32]%s[/img]x%s uses"
		% [Tools.TOOLS[stats["tool"].type].icon, stats["tool"].quantity]
	)


func _ready():
	load_levels()
	setup_gui()


func _process(delta):
	$CameraAnchor.rotate_y(delta * 0.1)


func _on_BackButton_pressed() -> void:
	if level_idx == 0:
		return

	level_idx -= 1
	setup_gui()


func _on_NextButton_pressed() -> void:
	if level_idx == levels.size() - 1:
		return

	level_idx += 1
	setup_gui()


func _on_PlayButton_pressed() -> void:
	Globals.level = levels[level_idx][1]
	get_tree().change_scene(s_level)
	print("Loading level: " + Globals.level)
