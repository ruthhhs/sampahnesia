extends Node3D



func _on_child_entered_tree(_node: Node) -> void:
	if get_child_count() > 0:
		Archivement.validate_archivement(0)
	if get_child_count() >= 5:
		Archivement.validate_archivement(5)
	if get_child_count() >= 15:
		Archivement.validate_archivement(7)
