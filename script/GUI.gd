extends CanvasLayer

var level

func _ready() -> void:
	level = get_parent()


func setup(level_data: Dictionary) -> void:
	$Control/LevelInfo/LevelName.text = level_data["name"]

	$Control/Toolbar/Tool/TextureRect.texture = load(
		"%s" % Tools.TOOLS[level.topple_tool].icon
	)


func _process(_delta):
	for button in $Control/Toolbar.get_children():
		if level.selected_tool == button.name:
			button.set_disabled(true)
		else:
			button.set_disabled(false)

	if level.gamemode:
		level.gamemode.update_gui(self)


func _on_Move_pressed() -> void:
	level.selected_tool = "Move"
	$Control/Scope.position = Vector2(-16, -16)


func _on_Tool_pressed() -> void:
	level.selected_tool = "Tool"
	$Control/Scope.position = Vector2(-16, -16)
