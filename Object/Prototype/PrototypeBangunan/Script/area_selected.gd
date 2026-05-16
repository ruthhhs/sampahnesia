extends Area3D

@export var my_parent: Area3D 
var target:Area3D

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("bangunan") :
		if not area.global_position == my_parent.global_position and not area.list_node_tersambung.has(my_parent)and not my_parent.list_node_tersambung.has(area):
			#if area.is_in_group("bangunan"):
			print("kena di: " + str(area.global_position))
			area.list_node_tersambung.append(my_parent)
			#my_parent.list_node_tersambung.append(area)
			my_parent.pinned_position = area.global_position
			target = area
