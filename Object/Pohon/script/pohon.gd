extends Area3D

func delete_my_self() -> void:
	queue_free()

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if Global.currently_are_delete == true :
			delete_my_self()
