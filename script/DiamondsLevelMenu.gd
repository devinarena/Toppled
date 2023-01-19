extends "res://script/LevelMenu.gd"

const initial_index = 1000

const diamond_block = preload("res://scenes/blocks/BlockDiamond.tscn")


func _ready():
	level_dir = "diamonds"

	$Control/LevelStats/HighScore.add_color_override(
		"default_color", Globals.level_type_data.diamonds.text_color
	)


func load_levels() -> void:
	var dir = Directory.new()
	if dir.open("res://levels/diamonds") == OK:
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
			var path = "res://levels/diamonds/%s.json" % level
			if file.open(path, File.READ) == OK:
				var data = parse_json(file.get_as_text())
				file.close()

				var stats = {
					"level": level,
					"total_blocks": 0,
					"diamond_blocks": 0,
					"block_mass": 0,
					"tool":
					{
						"type": "none",
						"quantity": 0,
					},
					"one_star": data.rules.one_star,
					"two_star": data.rules.two_star,
					"three_star": data.rules.three_star,
				}

				for block in data.blocks:
					stats.total_blocks += 1
					stats.block_mass += (block.scale.x * block.scale.y * block.scale.z)

					if block.type == "diamond":
						stats.diamond_blocks += 1

				if data.rules["tool"]:
					stats["tool"].type = data.rules["tool"].type
					stats["tool"].quantity = data.rules["tool"].quantity

				level_stats[lname] = stats
				if data.id - initial_index >= level_list.size():
					level_list.resize(data.id - initial_index + 1)
				level_list[data.id - initial_index] = lname

			level = dir.get_next()


func setup_gui() -> void:
	var level = level_list[level_idx]
	$Control/LevelName.text = "%s. %s" % [level_idx + 1, level]

	var stats = level_stats[level]

	var score = Globals.save.levels[stats.level] if stats.level in Globals.save.levels else 0

	$Control/LevelStats/HighScore.bbcode_text = (
		"[center]Best: [img=16]res://assets/diamond_icon.png[/img]%s/[img=16]res://assets/diamond_icon.png[/img]%s[/center]"
		% [score, stats.diamond_blocks]
	)

	$Control/LevelStats/TotalBlocks.bbcode_text = (
		"[img=32x32]res://assets/blocks/normal.png[/img]x%s blocks"
		% stats.total_blocks
	)
	$Control/LevelStats/TotalPointBlocks.bbcode_text = (
		"[img=32x32]res://assets/blocks/diamond.png[/img]x%s blocks"
		% stats.diamond_blocks
	)
	$Control/LevelStats/BlockMass.bbcode_text = (
		"[img=32x32]res://assets/blocks/normal.png[/img]x%s kg"
		% stats.block_mass
	)
	$Control/LevelStats/ToolUses.bbcode_text = (
		"[img=32x32]%s[/img]x%s uses"
		% [Tools.TOOLS[stats["tool"].type].icon, stats["tool"].quantity]
	)

	var stars = 0
	if score >= level_stats[level].one_star:
		stars += 1
	if score >= level_stats[level].two_star:
		stars += 1
	if score >= level_stats[level].three_star:
		stars += 1

	for i in range(stars):
		$Control/StarContainer.get_node("Star%sEmpty" % (i + 1)).hide()
		$Control/StarContainer.get_node("Star%sFilled" % (i + 1)).show()
	for i in range(stars, 3):
		$Control/StarContainer.get_node("Star%sFilled" % (i + 1)).hide()
		$Control/StarContainer.get_node("Star%sEmpty" % (i + 1)).show()


func _on_SpawnTimer_timeout() -> void:
	var b = diamond_block.instance()
	b.global_transform.origin = $Background/SpawnPoint.global_transform.origin
	b.apply_impulse(
		Vector3(randf() - randf(), randf() - randf(), randf() - randf()), Vector3(0.5, 2, 0.5)
	)
	$Background.add_child(b)
