extends Node

# Temp code for converting a scene to json


func serialize() -> Dictionary:
	var res = {"blocks": []}

	for child in get_children():
		var block = {}
		if "BlockPoints" in child.name:
			block["type"] = "points"
			block["value"] = child.value
		elif "BlockImmovable" in child.name:
			block["type"] = "immovable"
		elif "BlockCracked" in child.name:
			block["type"] = "cracked"
		elif "BlockDiamond" in child.name:
			block["type"] = "diamond"
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
		block["rotation"] = {
			"x": child.rotation_degrees.x,
			"y": child.rotation_degrees.y,
			"z": child.rotation_degrees.z
		}
		res.blocks.append(block)

	return res
