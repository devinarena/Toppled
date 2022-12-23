extends Spatial

const MINIMUM_ZOOM = 3.0
const DEFAULT_ZOOM = 10.0

var scope: Node
var drag_origin: Vector2
var level: Node
var zoom: float = DEFAULT_ZOOM

func _ready():
	level = get_parent()
	scope = level.get_node("GUI/Scope")

	$Camera.global_transform.origin = Vector3(0, DEFAULT_ZOOM, DEFAULT_ZOOM)
	Swipe.connect("swipe", self, "_on_swipe")


func use_tool(strength: float) -> void:
	var bb = load("res://scenes/tools/Baseball.tscn").instance()

	var vscale = zoom / DEFAULT_ZOOM

	bb.initial_velocity = $Camera.project_ray_normal(scope.position).normalized() * vscale * strength
	print(bb.initial_velocity)

	level.get_node("Projectiles").add_child(bb)
	bb.global_transform.origin = $Camera.global_transform.origin


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if level.selected_tool == "Move":
			if event.pressed:
				drag_origin = event.global_position
			else:
				drag_origin = Vector2.ZERO
	
	if event is InputEventMouseMotion:
		if level.selected_tool == "Move":
			if drag_origin:
				var delta = event.global_position.x - drag_origin.x
				drag_origin = event.global_position
				rotate_y(delta * 0.01)

func _on_swipe(end_position: Vector2, strength: float) -> void:
	if level.selected_tool == "Tool":
		if abs(strength) <= 10:
			scope.position = end_position
		else:
			if scope.position != Vector2(-16, -16):
				use_tool(strength)
				scope.position = Vector2(-16, -16)
