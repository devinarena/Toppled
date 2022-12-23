extends CanvasLayer

var level

func _ready() -> void:
	level = get_parent()

func _process(delta):
	for button in $Toolbar.get_children():
		if level.selected_tool == button.name:
			button.set_disabled(true)
		else:
			button.set_disabled(false)


func _on_Move_pressed() -> void:
	level.selected_tool = "Move"
	$Scope.position = Vector2(-16, -16)


func _on_Tool_pressed() -> void:
	level.selected_tool = "Tool"
	$Scope.position = Vector2(-16, -16)
