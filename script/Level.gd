extends Node

const star = preload("res://assets/star.png")

var block_scenes: Dictionary = {
	"normal": load("res://scenes/blocks/Block.tscn"),
	"points": load("res://scenes/blocks/BlockPoints.tscn"),
	"immovable": load("res://scenes/blocks/BlockImmovable.tscn"),
	"cracked": load("res://scenes/blocks/BlockCracked.tscn"),
	"diamond": load("res://scenes/blocks/BlockDiamond.tscn"),
}

var selected_tool: String = "Move"

var gamemode
var topple_tool: String = ""
var tool_uses: int = 0
var game_over: bool = false
var farthest = 0

func _ready():
	var level = load_file("res://levels/%s/%s.json" % [Globals.level_dir, Globals.level])
	var level_data = get_dictionary_from_json(level)
	load_blocks(level_data)
	load_level_data(level_data)
	$GUI.setup(level_data)

	$Player.connect("tool_used", self, "_on_Tool_used")

	var target = "diamonds/Ramp"

	if Globals.level == target.split("/")[1]:
		var l = load("res://scenes/LevelGenerator.tscn").instance()
		add_child(l)
		var new_blocks = l.serialize().blocks

		var file = File.new()
		file.open("res://levels/%s.json" % target, File.READ)
		var level_str = file.get_as_text()
		file.close()

		var json = parse_json(level_str)
		print(json)
		json.blocks = new_blocks

		file.open("res://levels/%s.json" % target, File.WRITE)
		file.store_string(to_json(json))
		file.close()

		l.queue_free()

	$Player.set_zoom(farthest * 1.25)
	get_tree().paused = true
	show_popup("%s" % Globals.level, Globals.level_type_data[level_data.rules.type].description, 0)


func load_file(path: String) -> String:
	var file = File.new()
	file.open(path, File.READ)

	var res = file.get_as_text()

	file.close()

	return res


func get_dictionary_from_json(level: String) -> Dictionary:
	var res = JSON.parse(level)
	if res.error:
		print("Error parsing JSON: ", res.error)
		return {}
	else:
		return res.result


func load_blocks(data: Dictionary) -> void:
	for block in data.blocks:
		var b = block_scenes[block.type].instance()
		for property in block:
			if property == "scale" or property == "position":
				continue
			b.set(property, block[property])

		$Blocks.add_child(b)

		b.global_transform.origin = Vector3(block.position.x, block.position.y, block.position.z)
		b.scale(Vector3(block.scale.x, block.scale.y, block.scale.z))
		b.rotation_degrees = Vector3(block.rotation.x, block.rotation.y, block.rotation.z)

		farthest = max(farthest, b.global_transform.origin.distance_to(Vector3.ZERO) + b.get_node("Mesh").mesh.size.length())


func load_level_data(data: Dictionary) -> void:
	match data.rules.type:
		"points":
			gamemode = load("res://script/gamemode/PointsMode.gd").new(
				self, data.rules.one_star, data.rules.two_star, data.rules.three_star
			)
		"diamonds":
			gamemode = load("res://script/gamemode/DiamondsMode.gd").new(
				self, data.rules.one_star, data.rules.two_star, data.rules.three_star
			)
		"destruction":
			gamemode = load("res://script/gamemode/DestructionMode.gd").new(
				self, data.rules.one_star, data.rules.two_star, data.rules.three_star
			)
	topple_tool = data.rules["tool"].type
	tool_uses = data.rules["tool"].quantity


func award_points(points: int) -> void:
	gamemode.award_points(points)

	if game_over:
		return

	if gamemode.check_win_condition() != -1 and $EndTimer.is_stopped():
		$EndTimer.start(3)


func show_popup(title: String, desc: String, buttons: int) -> void:
	$GUI/Control/Dialog/CenterContainer/VBoxContainer/Title.text = title
	$GUI/Control/Dialog/CenterContainer/VBoxContainer/Description.text = desc
	if buttons == 0:
		$GUI/Control/Dialog/CenterContainer/VBoxContainer/StartButtons.show()
		$GUI/Control/Dialog/CenterContainer/VBoxContainer/EndButtons.hide()
	else:
		$GUI/Control/Dialog/CenterContainer/VBoxContainer/StartButtons.hide()
		$GUI/Control/Dialog/CenterContainer/VBoxContainer/EndButtons.show()
	$GUI/Control/Dialog.show()


func get_blocks() -> Array:
	return $Blocks.get_children()


# CALLBACKS


func _on_Tool_used() -> void:
	if tool_uses == 0:
		$EndTimer.start()


func _on_EndTimer_timeout() -> void:
	if game_over:
		return

	game_over = true

	var res = gamemode.check_final_result()

	if res:
		Globals.save.levels[Globals.level] = gamemode.score
		Globals.save_data()

		for child in $GUI/Control/Dialog/CenterContainer/VBoxContainer/HBoxContainer.get_children():
			if res > 0:
				child.get_node("Star").texture = star
				res -= 1
		show_popup("Final Results", "You successfully completed the level.", 1)
	else:
		show_popup("Final Results", "You didn't score enough to complete the level. Try again?", 1)


func _on_HomeButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_RetryButton_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_StartButton_pressed() -> void:
	get_tree().paused = false
	$GUI/Control/Dialog.hide()

