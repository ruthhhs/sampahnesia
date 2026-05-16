extends Node3D
@export var oxigen_per_tree: int = 2

func _input(_event: InputEvent) -> void:
	$BangunanLabel.text = "bangunan: " + str(get_child_count()-1)

func _on_child_entered_tree(node: Node) -> void:
	var total_pollution: int
	for i in get_children():
		if i.get_class() == "Area3D":
			total_pollution += i.jumlah_polusi
	Global.stat_polution = total_pollution

func _on_child_exiting_tree(node: Node) -> void:
	if node.get_class() == "Area3D":
		Global.stat_polution -= node.jumlah_polusi

func _on_nature_child_entered_tree(node: Node) -> void:
	Global.stat_oxigen = %Nature.get_child_count() * oxigen_per_tree

func _on_nature_child_exiting_tree(node: Node) -> void:
	Global.stat_oxigen = %Nature.get_child_count() * oxigen_per_tree
