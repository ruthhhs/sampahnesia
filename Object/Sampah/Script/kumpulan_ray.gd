extends Node3D



func _on_child_entered_tree(_node: Node) -> void:
	if get_child_count() >= 2:
		Global.first_sampah_double_linked = true
