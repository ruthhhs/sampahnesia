extends Marker2D

var radius_interact: float = 50.0
@onready var line_interact: Line2D = $LineInteract
@onready var interact_area: Area2D = $InputArea/InteractArea

var can_move_interact: bool = false
var is_connected: bool = false
@export var target_area: Area2D

# Variabel statis untuk memastikan hanya 1 marker yang aktif ditarik dalam satu waktu
static var active_marker: Marker2D = null

func _ready() -> void:
	# Pastikan area interaksi mendeteksi sinyal mouse jika diperlukan, 
	# atau kita pakai pengecekan jarak di _process / _input
	pass

func _input(event: InputEvent) -> void:
	if is_connected:
		return

	# Cek jarak mouse ke marker ini (menggunakan koordinat global agar akurat)
	var mouse_pos = get_global_mouse_position()
	var distance = global_position.distance_to(mouse_pos)
	
	# Jika mouse berada di dalam radius interaksi marker ini
	if distance <= radius_interact:
		if event.is_action_pressed("mouse_selected"):
			active_marker = self
			can_move_interact = true
	
	# Jika marker ini yang sedang aktif ditarik
	if active_marker == self:
		if Input.is_action_pressed("mouse_selected") and can_move_interact:
			# Ubah posisi lokal mouse untuk Line2D
			var local_mouse = get_local_mouse_position()
			line_interact.set_point_position(1, local_mouse)
			interact_area.position = local_mouse
			
		elif Input.is_action_just_released("mouse_selected"):
			reset()
			active_marker = null

func reset() -> void:
	line_interact.set_point_position(1, Vector2.ZERO)
	interact_area.position = Vector2.ZERO
	can_move_interact = false
	if active_marker == self:
		active_marker = null

func connected() -> void:
	is_connected = true
	var target_pos = target_area.get_parent().get_parent().position - get_parent().position
	line_interact.set_point_position(1, target_pos)
	interact_area.position = target_pos
	if active_marker == self:
		active_marker = null
	get_parent().get_parent().get_parent().unfinished_processed -= 1

func _on_playable_area_area_exited(area: Area2D) -> void:
	if area == interact_area:
		reset()

func _on_interact_area_area_entered(area: Area2D) -> void:
	if area == target_area:
		connected()
