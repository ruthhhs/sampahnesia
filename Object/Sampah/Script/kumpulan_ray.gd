extends Node3D



func _on_child_entered_tree(node: Node) -> void:
	if get_child_count() >= 1:
		Global.first_sampah_double_linked = true
