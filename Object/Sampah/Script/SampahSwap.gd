extends Node3D

@onready var sampah_full = $Sampah/SampahBesar
@onready var sampah_medium = $Sampah/SampahMedium
@onready var sampah_kecil = $Sampah/SampahKecil
@onready var animasi :AnimationPlayer= $Sampah/AnimationPlayer
var is_empty : bool = false
func _ready() -> void:
	animasi.play("Change")
func full()->void:
	sampah_full.visible = true
	sampah_medium.visible = false
	sampah_kecil.visible = false
	is_empty = false
	animasi.play("Change")
func medium()->void:
	sampah_full.visible = false
	sampah_medium.visible = true
	sampah_kecil.visible = false
	is_empty = false
	animasi.play("Change")
func small()->void:
	sampah_full.visible = false
	sampah_medium.visible = false
	sampah_kecil.visible = true
	is_empty = false
	animasi.play("Change")
func empty()->void:
	sampah_full.visible = false
	sampah_medium.visible = false
	sampah_kecil.visible = false
	is_empty = true



func _on_kumpulan_ray_child_order_changed() -> void:
	if is_empty and %KumpulanRay.get_child_count()<= 0:
		get_parent().delete_my_self()
