extends Node3D

@onready var sampah_full = $Sampah/SampahBesar
@onready var sampah_medium = $Sampah/SampahMedium
@onready var sampah_kecil = $Sampah/SampahKecil
func _ready() -> void:
	full()
func full()->void:
	sampah_full.visible = true
	sampah_medium.visible = false
	sampah_kecil.visible = false
func medium()->void:
	sampah_full.visible = false
	sampah_medium.visible = true
	sampah_kecil.visible = false
func small()->void:
	sampah_full.visible = false
	sampah_medium.visible = false
	sampah_kecil.visible = true
func empty()->void:
	sampah_full.visible = false
	sampah_medium.visible = false
	sampah_kecil.visible = false
