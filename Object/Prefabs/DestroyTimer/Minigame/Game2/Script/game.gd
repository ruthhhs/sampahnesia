extends Node2D
@export var water_tank : ProgressBar 
@export var dam: TextureRect
@export var flood: TextureRect
func _ready() -> void:
	water_tank.value = water_tank.min_value
func _process(_delta: float) -> void:
	var center_pos = get_parent().size/2
	$Steering.position.y = center_pos.y
	$Steering.position.x = center_pos.x/2
	dam.position.y = -$Steering.nilai_aktual_dam
	flood.modulate = Color(1.0,1.0,1.0,inverse_lerp(water_tank.min_value, water_tank.max_value, water_tank.value))
func _on_timer_timeout() -> void:
	if water_tank != null:
		if water_tank.value != water_tank.max_value:
			water_tank.value += $Steering.accumulated_rotation / 10
			print($Steering.accumulated_rotation)
		else:
			get_parent().get_parent().is_complete = true 
