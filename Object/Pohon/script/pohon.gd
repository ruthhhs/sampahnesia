extends Area3D

@onready var waiting_for_delete = preload("res://Assets/Shaders/WaitingForDelete.tres")

func delete_my_self() -> void:
	queue_free()

@warning_ignore("unused_parameter")
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if Global.currently_are_delete == true :
			delete_my_self()

func _on_mouse_entered() -> void:
	if Global.currently_are_delete == true:
		get_child(0).get_child(1).get_child(0).material_overlay = waiting_for_delete

func _on_mouse_exited() -> void:
	if Global.currently_are_delete == true:
		get_child(0).get_child(1).get_child(0).material_overlay = null
