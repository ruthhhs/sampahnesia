extends Node3D




func _on_child_entered_tree(_node: Node) -> void:
	Global.first_nanem_pohon = true
	if get_child_count() >= 10:
		
		Archivement.validate_archivement(1)
