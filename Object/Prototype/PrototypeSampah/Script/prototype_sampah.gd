class_name Sampah
extends Area3D

@onready var raycaster = preload("res://Object/Prototype/PrototypeSampah/raycaster.tscn")
@onready var kumpulan_ray :Node3D = $KumpulanRay
func add_raycast()->void:
	var raycaster_instanciate = raycaster.instantiate() 
	kumpulan_ray.add_child(raycaster_instanciate)
	raycaster_instanciate.global_position = kumpulan_ray.global_position 
	raycaster_instanciate.dragging_access = true
func _reset_drag_multiple(node: Area3D)->void:
	for child in kumpulan_ray.get_children():
		if child is RayCast3D and child.target_send == node:
			child.queue_free()

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and Global.currently_are_delete == false:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if kumpulan_ray.get_child_count() == 0:
				add_raycast()
				kumpulan_ray.get_child(kumpulan_ray.get_child_count() - 1).my_parent = self
			else:
				if kumpulan_ray.get_child(kumpulan_ray.get_child_count() - 1).target_send != null:
					add_raycast()
					kumpulan_ray.get_child(kumpulan_ray.get_child_count() - 1).my_parent = self
				else:
					kumpulan_ray.get_child(kumpulan_ray.get_child_count() - 1).dragging_access = true
			
			print(kumpulan_ray.get_child_count())
