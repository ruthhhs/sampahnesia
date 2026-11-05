extends Area3D

func _ready() -> void:
	Global.delete_change.connect(enable_delete)
	$CollisionShape3D.disabled = Global.currently_are_delete
func enable_delete(value: bool)-> void:
	$CollisionShape3D.disabled = value


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("raycaster"):
		area.get_parent().get_parent()._on_interact_to_line_mouse_entered()
#_on_interact_to_line_mouse_entered()
#_on_interact_to_line_mouse_exited()
func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("raycaster"):
		area.get_parent().get_parent()._on_interact_to_line_mouse_exited()
