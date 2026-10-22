extends Marker2D
var id_object_input: int
var radius_interact: float = 50.0
@onready var interact_area: Area2D = $InputArea/InteractArea

var can_move_interact: bool = false
@warning_ignore("shadowed_variable_base_class")
var is_connected: bool = false
@export var target_area: Area2D
@export var input_texture: CompressedTexture2D:
	set(value):
		if value != input_texture:
			input_texture = value
			print("telah terganti oleh value: ", value)
			%Sprite2D.texture = value
# Variabel statis untuk memastikan hanya 1 marker yang aktif ditarik dalam satu waktu
static var active_marker: Marker2D = null
var target_position: Vector2
func _ready() -> void:
	print(input_texture)

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
			interact_area.position = local_mouse
			
		elif Input.is_action_just_released("mouse_selected"):
			reset()
			active_marker = null

func reset() -> void:
	interact_area.position = Vector2.ZERO
	can_move_interact = false
	if active_marker == self:
		active_marker = null

func connected() -> void:
	is_connected = true
	#var target_pos = target_area.get_parent().get_parent().position - get_parent().position
	interact_area.global_position = target_position
	if active_marker == self:
		active_marker = null
	get_parent().get_parent().get_parent().unfinished_processed -= 1

func _on_playable_area_area_exited(area: Area2D) -> void:
	if area == interact_area:
		reset()

func _on_interact_area_area_entered(area: Area2D) -> void:
	if "id_object_output" in area.get_parent():
		print("ada")
		if area.get_parent().id_object_output == id_object_input:
			print("konek")
			target_position = area.get_parent().global_position
		
		
			connected()
