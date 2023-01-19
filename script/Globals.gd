extends Node

var level_dir = ""
var level = ""

var save = {"levels": {}}

var level_type_data = {
	"destruction":
	{
		"description": "Topple as many blocks as you can!",
		"text_color": Color(0.8, 0.8, 0.8),
	},
	"points":
	{
		"description": "Knock down as many point blocks as you can!",
		"text_color": Color(0.8, 0.8, 0),
	},
	"diamonds":
	{
		"description": "Knock down as many diamond blocks as you can!",
		"text_color": Color(0, 0.8, 0.8),
	},
}


func _ready():
	load_data()


func save_data() -> void:
	var file = File.new()
	file.open("user://save.json", File.WRITE)
	file.store_string(to_json(save))
	file.close()


func load_data() -> void:
	var file = File.new()
	if file.file_exists("user://save.json"):
		file.open("user://save.json", File.READ)
		var data = file.get_as_text()
		file.close()
		save = parse_json(data)
	else:
		save = {
			"levels": {},
		}
