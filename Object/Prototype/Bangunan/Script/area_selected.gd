extends Area3D


@export var my_parent: RayCast3D

func _input(event: InputEvent) -> void:
	if my_parent.dragging_access:
		global_position.x = Global.mouse_pos.x
		global_position.z = Global.mouse_pos.z
	else:
		global_position.x = my_parent.global_position.x
		global_position.z = my_parent.global_position.z
		
