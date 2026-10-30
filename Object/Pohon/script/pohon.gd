extends Area3D

@onready var waiting_for_delete = preload("res://Assets/Shaders/WaitingForDelete.tres")

# Ambil referensi ke node anak sesuai hirarki gambar
@onready var daun_enable: MeshInstance3D = $StarterAnim/Pohon/DaunEnable
@onready var daun_disable: MeshInstance3D = $StarterAnim/Pohon/DaunDisable
@onready var tangkai: MeshInstance3D = $StarterAnim/Pohon/Tangkai

# Menyimpan status asli pohon saat kondisi normal
var is_currently_active: bool = true

func _ready() -> void:
	Global.delete_change.connect(_on_delete_change)
	# Set tampilan awal (misal secara default aktif/hijau)
	set_active_state(true)

func delete_my_self() -> void:
	queue_free()

# Fungsi khusus untuk mengatur mode Enable (Hijau) / Disable (Merah)
func set_active_state(is_active: bool) -> void:
	is_currently_active = is_active
	
	if daun_enable:
		daun_enable.visible = is_active
	if daun_disable:
		daun_disable.visible = not is_active

@warning_ignore("unused_parameter")
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if Global.currently_are_delete:
			delete_my_self()

func _on_mouse_entered() -> void:
	if Global.currently_are_delete:
		_apply_delete_overlay(true)

func _on_mouse_exited() -> void:
	_apply_delete_overlay(false)

func _on_delete_change(is_deleting: bool) -> void:
	if not is_deleting:
		_apply_delete_overlay(false)

# Fungsi pembantu untuk mengatur tampilan saat kursor hover di mode delete
func _apply_delete_overlay(enable: bool) -> void:
	if enable:
		# Saat kursor masuk di mode hapus: paksa tampilkan daun merah & beri overlay ke tangkai
		if daun_enable: daun_enable.visible = false
		if daun_disable: daun_disable.visible = true
		if tangkai: tangkai.material_overlay = waiting_for_delete
	else:
		# Saat kursor keluar: kembalikan visibilitas daun ke status aslinya & hapus overlay tangkai
		set_active_state(is_currently_active)
		if tangkai: tangkai.material_overlay = null
