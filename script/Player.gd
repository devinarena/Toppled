extends Spatial

const DEFAULT_ZOOM = 8.0

const MIN_ZOOM: float = 5.0
var MAX_ZOOM: float = 30.0

var scope: Node
var drag_origin: Vector2
var level: Node
var y_zoom_factor: float = 0.5
var original_z

var events: Dictionary = {}
var last_drag_distance: float = 0.0

signal tool_used


func _ready():
	level = get_parent()
	scope = level.get_node("GUI/Control/Scope")

	reset_camera_position()
	Swipe.connect("swipe", self, "_on_swipe")


func reset_camera_position() -> void:
	set_camera_position(DEFAULT_ZOOM, DEFAULT_ZOOM)


func set_camera_position(y: float, z: float) -> void:
	original_z = z
	MAX_ZOOM = z * 6
	$Camera.global_transform.origin = Vector3(0, y, z)


func use_tool(strength: float) -> void:
	if level.tool_uses == 0:
		return

	level.tool_uses -= 1

	var t = load(Tools.TOOLS[level.topple_tool].scene).instance()

	var vscale = $Camera.global_transform.origin.length() / original_z

	t.initial_velocity = $Camera.project_ray_normal(scope.position).normalized() * vscale * strength

	level.get_node("Projectiles").add_child(t)
	t.global_transform.origin = $Camera.global_transform.origin

	emit_signal("tool_used")


func _unhandled_input(event: InputEvent) -> void:
	# if event is InputEventMouseButton:
	# 	if level.selected_tool == "Move":
	# 		if event.pressed:
	# 			drag_origin = event.global_position
	# 		else:
	# 			drag_origin = Vector2.ZERO
	# if event is InputEventMouseMotion:
	# 	if level.selected_tool == "Move":
	# 		if drag_origin:
	# 			var delta = event.global_position.x - drag_origin.x
	# 			drag_origin = event.global_position
	# 			rotate_y(-delta * 0.01)

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP or event.button_index == BUTTON_WHEEL_DOWN:
			var delta = 0.25 * (1 if event.button_index == BUTTON_WHEEL_DOWN else -1)

			var dist = $Camera.global_transform.origin.distance_to(Vector3.ZERO)
			if (
				(delta < 0 and dist > MIN_ZOOM) or
				(delta > 0 and dist < MAX_ZOOM)
			):
				$Camera.translate(Vector3(0, delta * y_zoom_factor, delta))

	if event is InputEventScreenTouch:
		if level.selected_tool == "Move":
			if event.pressed:
				events[event.index] = event
			else:
				events.erase(event.index)

	if event is InputEventScreenDrag:
		if level.selected_tool == "Move":
			events[event.index] = event
			if events.size() == 1:
				# rotate camera about origin in x, y, and z directions
				rotate_y(-event.relative.x * 0.01)
			if events.size() == 2:
				var drag_distance = events[0].position.distance_to(events[1].position)
				if last_drag_distance != 0:
					var delta = (last_drag_distance - drag_distance) * 0.02

					$Camera.translate(Vector3(0, delta * y_zoom_factor, delta))
					if $Camera.global_transform.origin.z < MIN_ZOOM:
						var diff = MIN_ZOOM - $Camera.global_transform.origin.z
						$Camera.translate(Vector3(0, diff * y_zoom_factor, diff))
					elif $Camera.global_transform.origin.z > MAX_ZOOM:
						var diff = MAX_ZOOM - $Camera.global_transform.origin.z
						$Camera.translate(Vector3(0, diff * y_zoom_factor, diff))

				last_drag_distance = drag_distance
			
			if events.size() != 2:
				last_drag_distance = 0


func _on_swipe(end_position: Vector2, strength: float) -> void:
	if level.selected_tool == "Tool":
		if abs(strength) <= 10:
			scope.position = end_position
		else:
			if scope.position != Vector2(-16, -16):
				use_tool(strength)
				scope.position = Vector2(-16, -16)
