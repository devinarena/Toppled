extends Node

var block_scenes: Dictionary = {
	"normal": load("res://scenes/blocks/Block.tscn"),
	"points": load("res://scenes/blocks/BlockPoints.tscn"),
	# "immovable": load("res://scenes/block/ImmovableBlock.tscn"),
}

var selected_tool: String = "Move"

func _ready():
	var level = load_file("res://levels/Tower.json")
	var level_data = get_dictionary_from_json(level)
	print(level_data)
	load_blocks(level_data)


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
		
		$Blocks.add_child(b)

		b.global_transform.origin = Vector3(block.position.x, block.position.y, block.position.z)
