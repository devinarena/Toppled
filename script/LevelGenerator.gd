extends Node

# Temp code for converting a scene to json

func serialize() -> Dictionary:
	var res = {"blocks": []}

	for child in get_children():
		var block = {}
		if "BlockPoints" in child.name:
			block["type"] = "points"
			block["value"] = child.value
		elif "Block" in child.name:
			block["type"] = "normal"
		else:
			print("Unknown node: " + child.name)
			return {}
		block["position"] = {
				"x": child.global_transform.origin.x,
				"y": child.global_transform.origin.y,
				"z": child.global_transform.origin.z
		}
		block["scale"] = {
				"x": child.global_transform.basis.get_scale().x,
				"y": child.global_transform.basis.get_scale().y,
				"z": child.global_transform.basis.get_scale().z
		}
		res.blocks.append(block)
	
	return res

func _ready():
	var f = File.new()
	f.open("res://temporary.json", File.WRITE)
	f.store_string(to_json(serialize()))
	f.close()
