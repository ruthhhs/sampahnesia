extends Node3D




func _on_child_entered_tree(node: Node) -> void:
	if get_child_count() > 0:
		Archivement.validate_archivement(2)
	if get_child_count() >= 5:
		Archivement.validate_archivement(6)
	if get_child_count() >= 10:
		Archivement.validate_archivement(8)
