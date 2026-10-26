extends Node3D

@export_group("stat awal")
@export var starter_money: int = 7000
@export var year_start: int = 0:
	set(value):
		if year_start != value:
			year_start = value
			if year_start >= 0:
				var is_rain: int #actual is boolean with 0,1 value
				is_rain = rng.randi_range(0,1)
				match is_rain:
					0:
						Global.currently_are_raining = true
					1:
						Global.currently_are_raining = true
@export var month: int = 0:
	set(value):
		if month != value:
			month = value
			send_month.emit(month)
@export var durasi_jabatan: int = 5
@export_group("Controller")
@export var zoom_speed: float = 2.0
@export var min_zoom: float = -50.0
@export var max_zoom: float = 100.0
@export var max_range_move: Vector3 = Vector3(100,0,100)

@onready var rotation_x: Node3D = $CameraRotationX
@onready var zoom_pivot: Camera3D = $CameraRotationX/CameraZoomPivot/Camera3D
@onready var camera: Camera3D = $CameraRotationX/CameraZoomPivot/Camera3D
@onready var mouse_follower_object: Marker3D = $MouseFollowerObject

signal send_month(month:int)

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var can_scroll: bool = true
var can_move: bool = true
var move_speed: float = 0.6
var move_target: Vector3
var zoom_target: float


var edge_size: float = 5.0
var scroll_speed: float = 0.6
var jarak: int = 1000

# Anti-double input
var last_click_time: float = 0.0
var click_cooldown: float = 0.2

func _ready() -> void:
	Global.is_selecting.connect(showing_building)
	Global.stat_money = starter_money
	can_move = true
	%Pause.visible = false
	move_target = position
	zoom_target = camera.position.z  
	%CityName.text = Global.name_city
	%YearLabel.text = str(year_start)
	%ValueMonth.text = str(month)
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if %Pause.visible == true:
			
			%Pause.visible = false
		else:
			%Pause.visible = true
	if can_move == true:
		
		# Handle zoom scroll
		if can_scroll:
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

func _physics_process(_delta: float) -> void:
	%MoneyLabel.text = str(Global.stat_money)
	# Edge scrolling
	if can_move == true : # Tambahin maksimum range posisi
		
		var mouse_pos = get_viewport().get_mouse_position()
		var viewport_size = get_viewport().get_visible_rect().size
		var scroll_direction = Vector3.ZERO
		var lerp_2D: Vector2
		lerp_2D.x = lerpf(0,viewport_size.x,mouse_pos.x)
		lerp_2D.y = (mouse_pos.y-0) / (viewport_size.y-0)
		
		%ValuePositionDebug.text = str(move_target, " | ", global_position)
		if lerp_2D.y >= %TabContainer.anchor_top:
			can_scroll = false
		else:
			can_scroll = true
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


func mouse_position_from_cam() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * jarak
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = 0xFFFFFFFF  # Deteksi semua layer
	var collision = camera.get_world_3d().direct_space_state.intersect_ray(query)
	return collision.position if collision else Vector3.UP


func showing_building(toggled_on: bool)-> void:
	print("nilai toggled: ", toggled_on)
	if toggled_on != true:
		%UIAnimation.play("BuildingModeDisable")
	else:
		%UIAnimation.play_backwards("BuildingModeDisable")

func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.currently_are_delete = toggled_on

# tab ui in-out #


func _on_pause_visibility_changed() -> void:
	if %Pause.visible == true:
		can_move =false
		$CanvasLayer/GameUIBuilder.visible = false
	else:
		can_move = true
		$CanvasLayer/GameUIBuilder.visible = true

func _on_button_pressed() -> void:
	%Pause.visible = true

func _on_timer_watch_timeout() -> void:
	%Days.value += 1
	if %Days.value >= %Days.max_value:
		%Days.value = 0
		month += 1
		%ValueMonth.text = str(month)
	if month >= 12:
		month = 0
		year_start += 1
		%YearLabel.text = str(year_start)
	if year_start >= durasi_jabatan:
		%EndAnim.play("GameOver")
		#Transition.oksigen = Global.stat_oxigen
		#Transition.karbon_dioksida = Global.stat_polution
		#Transition.change_scnee("res://UI/Scnee/Popup/popupScore/popup_score.tscn")


func _on_end_anim_animation_finished(_anim_name: StringName) -> void:
	Transition.change_scnee("res://UI/Scnee/Cutscnee/ending.tscn")
