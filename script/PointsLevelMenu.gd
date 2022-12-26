extends Node

const s_level = "res://scenes/Level.tscn"

var level_idx: int = 0
var timer: float = 0.0

var level_list: Array = []
var level_stats = {}


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

			var file = File.new()
			var path = "res://levels/%s.json" % level
			if file.open(path, File.READ) == OK:
				var data = parse_json(file.get_as_text())
				file.close()

				var stats = {
					"level": level,
					"total_blocks": 0,
					"point_blocks": 0,
					"block_mass": 0,
					"tool":
					{
						"type": "none",
						"quantity": 0,
					},
				}

				for block in data.blocks:
					stats.total_blocks += 1
					stats.block_mass += (block.scale.x * block.scale.y * block.scale.z)

					if block.type == "points":
						stats.point_blocks += 1

				if data.rules["tool"]:
					stats["tool"].type = data.rules["tool"].type
					stats["tool"].quantity = data.rules["tool"].quantity

				level_stats[lname] = stats
				if data.id > level_list.size():
					level_list.append(lname)
				else:
					level_list.insert(data.id, lname)

			level = dir.get_next()


func setup_gui() -> void:
	var level = level_list[level_idx]
	$Control/LevelName.text = level

	var stats = level_stats[level]

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

	var stars = randi() % 4
	for i in range(stars):
		$Control/StarContainer.get_node("Star%sEmpty" % (i + 1)).hide()
		$Control/StarContainer.get_node("Star%sFilled" % (i + 1)).show()
	for i in range(stars, 3):
		$Control/StarContainer.get_node("Star%sFilled" % (i + 1)).hide()
		$Control/StarContainer.get_node("Star%sEmpty" % (i + 1)).show()


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
	if level_idx == level_list.size() - 1:
		return

	level_idx += 1
	setup_gui()


func _on_PlayButton_pressed() -> void:
	Globals.level = level_stats[level_list[level_idx]].level
	get_tree().change_scene(s_level)
	print("Loading level: " + Globals.level)
