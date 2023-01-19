extends Spatial

var original_zoom

var MIN_ZOOM = 5.0
var MAX_ZOOM = 10.0
var MAX_DISTANCE = 20.0

var scope: Node
var drag_origin: Vector2
var level: Node
var y_zoom_factor: float = 0.5
var original_pos: Vector3

var events: Dictionary = {}
var last_drag_distance: float = 0.0

signal tool_used


func _ready():
	level = get_parent()
	scope = level.get_node("GUI/Control/Scope")

	Swipe.connect("swipe", self, "_on_swipe")


func set_zoom(zoom_level: float):
	original_zoom = zoom_level
	var factor = abs(sin(deg2rad($Camera.fov)))
	$Camera.global_transform.origin.z = zoom_level / factor
	$Camera.global_transform.origin.y = zoom_level / factor

	MAX_ZOOM = zoom_level * 2
	MIN_ZOOM = zoom_level * 0.75
	MAX_DISTANCE = zoom_level * 2


func throw_tool(strength: float) -> void:
	if level.tool_uses == 0:
		return

	level.tool_uses -= 1

	var t = load(Tools.TOOLS[level.topple_tool].scene).instance()

	var vscale = clamp(abs($Camera.global_transform.origin.z / original_zoom) * 0.9, 0.8, 1.15)

	t.initial_velocity = $Camera.project_ray_normal(scope.position).normalized() * vscale * strength
	print(vscale)

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
	# 			var delta = (event.position - drag_origin) * 0.02
	# 			delta.x = clamp(delta.x, -0.1, 0.1)
	# 			delta.y = clamp(delta.y, -0.1, 0.1)
	# 			drag_origin = event.position
	# 			var old_y = $Camera.global_transform.origin.y
	# 			$Camera.translate(Vector3(-delta.x, 0, -delta.y))
	# 			$Camera.global_transform.origin.y = old_y
	# 			$Camera.global_transform.origin.x = (
	# 				sign($Camera.global_transform.origin.x)
	# 				* min(abs($Camera.global_transform.origin.x), MAX_DISTANCE)
	# 			)
	# 			$Camera.global_transform.origin.z = (
	# 				sign($Camera.global_transform.origin.z)
	# 				* min(abs($Camera.global_transform.origin.z), MAX_DISTANCE)
	# 			)

	if event is InputEventMouseButton:
		if level.selected_tool == "Move":
			if event.button_index == BUTTON_WHEEL_UP or event.button_index == BUTTON_WHEEL_DOWN:
				var delta = 0.25 * (1 if event.button_index == BUTTON_WHEEL_DOWN else -1)

				var dist = $Camera.global_transform.origin.distance_to(Vector3.ZERO)
				if (delta < 0 and dist > MIN_ZOOM) or (delta > 0 and dist < MAX_ZOOM):
					$Camera.translate(Vector3(0, delta * y_zoom_factor, delta))

	if event is InputEventScreenTouch:
		if level.selected_tool == "Move" or level.selected_tool == "Rotate":
			if event.pressed:
				events[event.index] = event
			else:
				events.erase(event.index)

	if event is InputEventScreenDrag:
		events[event.index] = event
		if level.selected_tool == "Rotate":
			if events.size() == 1:
				# rotate camera about origin in x, y, and z directions
				rotate_y(-event.relative.x * 0.01)
		elif level.selected_tool == "Move":
			if events.size() == 1:
				if drag_origin:
					var delta = (events[0].position - drag_origin) * 0.02
					drag_origin = events[0].position
					var old_y = $Camera.global_transform.origin.y
					$Camera.translate(Vector3(-delta.x, 0, -delta.y))
					$Camera.global_transform.origin.y = old_y
					$Camera.global_transform.origin.x = (
						sign($Camera.global_transform.origin.x)
						* min(abs($Camera.global_transform.origin.x), MAX_DISTANCE)
					)
					$Camera.global_transform.origin.z = (
						sign($Camera.global_transform.origin.z)
						* min(abs($Camera.global_transform.origin.z), MAX_DISTANCE)
					)
				else:
					drag_origin = events[0].position
			elif events.size() == 2:
				var drag_distance = events[0].position.distance_to(events[1].position)
				if last_drag_distance != 0:
					var delta = clamp((last_drag_distance - drag_distance) * 0.02, -0.1, 0.1)
					var distance = $Camera.global_transform.origin.distance_squared_to(Vector3.ZERO)

					if (
						(delta < 0 and distance > MIN_ZOOM * MIN_ZOOM)
						or (delta > 0 and distance < MAX_ZOOM * MAX_ZOOM)
					):
						$Camera.translate(Vector3(0, delta * y_zoom_factor, delta))

				last_drag_distance = drag_distance

	if events.size() != 2:
		last_drag_distance = 0
	if events.size() != 1:
		drag_origin = Vector2.ZERO


func _on_swipe(end_position: Vector2, strength: float) -> void:
	if level.selected_tool == "Tool":
		if abs(strength) <= 10:
			scope.position = end_position
		else:
			if scope.position != Vector2(-16, -16):
				throw_tool(strength)
				scope.position = Vector2(-16, -16)
