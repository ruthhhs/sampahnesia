extends Node3D

@onready var rotation_x: Node3D = $CameraRotationX
@onready var zoom_pivot: Camera3D = $CameraRotationX/CameraZoomPivot/Camera3D
@onready var camera: Camera3D = $CameraRotationX/CameraZoomPivot/Camera3D
@onready var mouse_follower_object: Marker3D = $MouseFollowerObject
@onready var fps_label: Label = $CanvasLayer/GameUIBuilder/TecStats/FPSLabel
@onready var mouse_pos_label: Label = $CanvasLayer/GameUIBuilder/TecStats/MousePositionLabel
@onready var money_label: Label = $CanvasLayer/GameUIBuilder/TecStats/MoneyLabel
@onready var pollution_label: Label = $CanvasLayer/GameUIBuilder/TecStats/PollutionLabel
@onready var oxigen_label: Label = $CanvasLayer/GameUIBuilder/TecStats/OxigenLabel
var move_speed: float = 0.6
var move_target: Vector3
var zoom_speed: float = 2.0
var zoom_target: float
var min_zoom: float = -10.0
var max_zoom: float = 40.0
var edge_size: float = 5.0
var scroll_speed: float = 0.6
var jarak: int = 1000

# Anti-double input
var last_click_time: float = 0.0
var click_cooldown: float = 0.2

func _ready() -> void:
	move_target = position
	zoom_target = camera.position.z  
	$CanvasLayer/InGameUi.visible = true
func _input(event: InputEvent) -> void:

		
	if Input.is_action_just_pressed("ui_accept"):
		if $CanvasLayer/GameUIBuilder.visible == true:
			$CanvasLayer/GameUIBuilder.visible = false
		else:
			$CanvasLayer/GameUIBuilder.visible = true
	# Handle zoom scroll
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_target = clamp(zoom_target - zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_target = clamp(zoom_target + zoom_speed, min_zoom, max_zoom)

	# Handle mouse click (spawn trigger)
	if event.is_action_pressed("mouse_build") and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var current_time = Time.get_ticks_msec() / 1000.0
			if current_time - last_click_time >= click_cooldown:
				last_click_time = current_time
				spawn_object()

func _physics_process(_delta: float) -> void:
	# Edge scrolling
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size
	var scroll_direction = Vector3.ZERO
	if mouse_pos.x < edge_size:
		scroll_direction.x = -1
	elif mouse_pos.x > viewport_size.x - edge_size:
		scroll_direction.x = 1
	if mouse_pos.y < edge_size:
		scroll_direction.z = -1
	elif mouse_pos.y > viewport_size.y - edge_size:
		scroll_direction.z = 1
	move_target += transform.basis * scroll_direction * scroll_speed
	# Keyboard input movement
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var movement_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	move_target += move_speed * movement_direction
	# Move camera toward target
	position = position.lerp(move_target, 0.10)
	zoom_pivot.position.z = lerp(zoom_pivot.position.z, zoom_target, 0.1)

	# Update mouse follower
	var ground_pos = mouse_position_from_cam()
	mouse_follower_object.global_position = ground_pos
	Global.mouse_pos = ground_pos
	mouse_pos_label.text = str(ground_pos)
	money_label.text = str("Money: ", Global.stat_money)
	# Update FPS label
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	pollution_label.text = str("Pollution: ", Global.stat_polution)
	oxigen_label.text = str("Oxigen: ", Global.stat_oxigen)

func mouse_position_from_cam() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * jarak
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = 0xFFFFFFFF  # Deteksi semua layer
	var collision = camera.get_world_3d().direct_space_state.intersect_ray(query)
	return collision.position if collision else Vector3.UP

func spawn_object():
	# TODO: Implementasikan logika spawn kamu di sini
	print("Object spawned at: ", Global.mouse_pos)

func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.currently_are_delete = toggled_on
