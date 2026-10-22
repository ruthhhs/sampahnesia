# Pasang di ROOT scene setiap minigame (Minigame1.tscn, Minigame2.tscn, dst.)
extends Control

var destroy_timer_node_insert: Node3D
var is_complete: bool = false:
	set(value):
		if is_complete == value:
			return
		is_complete = value
		if is_complete:
			if is_instance_valid(destroy_timer_node_insert):
				destroy_timer_node_insert.is_repair = true
			queue_free()

func _exit_tree() -> void:
	# kalau minigame ditutup tanpa selesai, izinkan bayar/coba lagi
	if not is_complete and is_instance_valid(destroy_timer_node_insert):
		destroy_timer_node_insert.repair_in_progress = false
