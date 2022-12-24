extends Node

const btnFnt = preload("res://assets/Font20.tres")
const s_level = "res://scenes/Level.tscn"

func _ready():
	var dir = Directory.new()
	if dir.open("res://levels") == OK:
		dir.list_dir_begin()
		var level = dir.get_next()
		while level:
			if level == ".." or level == ".":
				level = dir.get_next()
				continue
			
			level = level.split(".")[0]

			var button = Button.new()
			button.text = level
			button.connect("pressed", self, "_on_LevelButton_pressed", [level])
			button.add_font_override("font", btnFnt)
			$Control/ScrollContainer/VBoxContainer.add_child(button)
			
			level = dir.get_next()


func _on_LevelButton_pressed(level: String) -> void:
	Globals.level = level
	get_tree().change_scene(s_level)
	print("Loading level: " + level)
