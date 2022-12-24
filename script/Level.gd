extends Node

var block_scenes: Dictionary = {
	"normal": load("res://scenes/blocks/Block.tscn"),
	"points": load("res://scenes/blocks/BlockPoints.tscn"),
	# "immovable": load("res://scenes/block/ImmovableBlock.tscn"),
}

var selected_tool: String = "Move"

var game_mode: String = ""
var topple_tool: String = ""
var tool_uses: int = 0
var points: int = 0


func _ready():
	var level = load_file("res://levels/%s.json" % Globals.level)
	var level_data = get_dictionary_from_json(level)
	print(level_data)
	load_blocks(level_data)
	load_level_data(level_data)
	$GUI.setup(level_data)

	$Player.connect("tool_used", self, "_on_Tool_used")

	var l = load("res://scenes/LevelGenerator.tscn").instance()
	add_child(l)
	l.queue_free()


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
	for block in data["blocks"]:
		var b = block_scenes[block.type].instance()
		for property in block:
			if property == "scale" or property == "position":
				continue
			b.set(property, block[property])

		b.global_transform.origin = Vector3(block.position.x, block.position.y, block.position.z)
		b.scale(Vector3(block.scale.x, block.scale.y, block.scale.z))
			
		$Blocks.add_child(b)


func load_level_data(data: Dictionary) -> void:
	game_mode = data.rules.type
	topple_tool = data.rules["tool"].type
	tool_uses = data.rules["tool"].quantity


func _on_Tool_used() -> void:
	if tool_uses == 0:
		$EndTimer.start()


func _on_EndTimer_timeout() -> void:
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_HomeButton_pressed() -> void:
	get_tree().change_scene("res://scenes/MainMenu.tscn")
