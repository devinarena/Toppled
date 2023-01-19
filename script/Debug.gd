extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(delta) -> void:
	$Label.text = "FPS: %s\n" % [Engine.get_frames_per_second()]
