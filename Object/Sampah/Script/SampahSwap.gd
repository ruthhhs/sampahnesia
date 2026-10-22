extends Node3D

@onready var sampah_full = $Sampah/SampahBesar
@onready var sampah_medium = $Sampah/SampahMedium
@onready var sampah_kecil = $Sampah/SampahKecil
var is_empty : bool = false
func _ready() -> void:
	full()
func full()->void:
	sampah_full.visible = true
	sampah_medium.visible = false
	sampah_kecil.visible = false
	is_empty = false
func medium()->void:
	sampah_full.visible = false
	sampah_medium.visible = true
	sampah_kecil.visible = false
	is_empty = false
func small()->void:
	sampah_full.visible = false
	sampah_medium.visible = false
	sampah_kecil.visible = true
	is_empty = false
func empty()->void:
	sampah_full.visible = false
	sampah_medium.visible = false
	sampah_kecil.visible = false
	is_empty = true



func _on_kumpulan_ray_child_order_changed() -> void:
	if is_empty and %KumpulanRay.get_child_count()<= 0:
		get_parent().delete_my_self()
