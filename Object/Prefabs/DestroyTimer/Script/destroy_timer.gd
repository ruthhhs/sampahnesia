extends Node3D

var speed: float = 1.0
var is_repair: bool = false
var repair_in_progress: bool = false   # <-- tambahkan ini
func _ready() -> void:
	
	%ProgressBar.value = %ProgressBar.max_value
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
		
	
