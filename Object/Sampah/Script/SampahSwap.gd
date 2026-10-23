extends Node3D

@onready var sampah_full = $Sampah/SampahBesar
@onready var sampah_medium = $Sampah/SampahMedium
@onready var sampah_kecil = $Sampah/SampahKecil
@onready var animasi : AnimationPlayer = $Sampah/AnimationPlayer
var is_empty : bool = false

func _ready() -> void:
	animasi.play("Change")

func full() -> void:
	# Hanya jalankan jika sebelumnya bukan full (supaya animasi tidak ke-restart terus)
	if not sampah_full.visible:
		sampah_full.visible = true
		sampah_medium.visible = false
		sampah_kecil.visible = false
		is_empty = false
		animasi.stop()
		animasi.play("Change")

func medium() -> void:
	if not sampah_medium.visible:
		sampah_full.visible = false
		sampah_medium.visible = true
		sampah_kecil.visible = false
		is_empty = false
		animasi.stop()
		animasi.play("Change")

func small() -> void:
	if not sampah_kecil.visible:
		sampah_full.visible = false
		sampah_medium.visible = false
		sampah_kecil.visible = true
		is_empty = false
		animasi.stop()
		animasi.play("Change")
		

func empty() -> void:
	sampah_full.visible = false
	sampah_medium.visible = false
	sampah_kecil.visible = false
	is_empty = true
	$TimerDelete.start()

func _on_timer_delete_timeout() -> void:
	get_parent().delete_my_self()
