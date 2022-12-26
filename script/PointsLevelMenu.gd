extends Node

const s_level = "res://scenes/Level.tscn"

var level_idx: int = 0
var levels: Array = []
var timer: float = 0.0

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
	$Control/LevelName.text = levels[level_idx][0]


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
