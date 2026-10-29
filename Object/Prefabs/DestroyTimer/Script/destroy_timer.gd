extends Node3D

@onready var label_pengingat : Label = $Sprite3D/SubViewport/Control/VBoxContainer/KlikUntukPerbaiki

var speed: float = 1.0
var repair_in_progress: bool = false

# Gunakan setter agar setiap kali is_repair diubah jadi true, label langsung hilang
var is_repair: bool = false:
	set(value):
		is_repair = value
		_update_label_visibility()

func _ready() -> void:
	%ProgressBar.value = %ProgressBar.max_value
	
	# Sambungkan signal dari Global script
	Global.is_inspecting.connect(_on_is_inspecting_changed)
	
	# Set status awal
	_update_label_visibility()

func _update_label_visibility() -> void:
	if label_pengingat != null:
		# Label HANYA muncul jika sedang inspecting DAN BELUM di-repair
		label_pengingat.visible = Global.currently_are_inspecting and not is_repair

func _on_is_inspecting_changed(_inspecting: bool) -> void:
	_update_label_visibility()

func _on_repair_timer_timeout() -> void:
	if is_repair == false:
		if %ProgressBar.value <= %ProgressBar.min_value:
			print("harusnya hapus")
			get_parent().delete_my_self()
		%ProgressBar.value -= speed
	else:
		%ProgressBar.value += speed
		if %ProgressBar.value >= %ProgressBar.max_value:
			get_parent().on_maintenance = false
			queue_free()
