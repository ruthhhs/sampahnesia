extends Area3D

@onready var waiting_for_delete = preload("res://Assets/Shaders/WaitingForDelete.tres")

func _ready() -> void:
	# Hubungkan signal saat mode hapus berubah
	Global.delete_change.connect(_on_delete_change)

func delete_my_self() -> void:
	queue_free()

@warning_ignore("unused_parameter")
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if Global.currently_are_delete:
			delete_my_self()

func _on_mouse_entered() -> void:
	if Global.currently_are_delete:
		_apply_delete_overlay(true)

func _on_mouse_exited() -> void:
	# Selalu hapus overlay saat kursor keluar, tanpa cek mode delete
	_apply_delete_overlay(false)

func _on_delete_change(is_deleting: bool) -> void:
	# Jika keluar dari mode delete, paksa bersihkan overlay shader
	if not is_deleting:
		_apply_delete_overlay(false)

# Fungsi pembantu agar tidak duplikasi kode dan aman dari error null
func _apply_delete_overlay(enable: bool) -> void:
	if get_child_count() > 0 and get_child(0).get_child_count() > 1 and get_child(0).get_child(1).get_child_count() > 0:
		var target_mesh = get_child(0).get_child(1).get_child(0)
		if enable:
			target_mesh.material_overlay = waiting_for_delete
		else:
			target_mesh.material_overlay = null
