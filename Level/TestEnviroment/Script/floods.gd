extends Node3D
@export var maximum_pos_x: float = 204.249
@export var minimum_pos_x: float = -211.055
@export var maximum_pos_y: float = 157.79
@export var minimum_pos_y: float = -155.321
var flood_start: bool = false:
	set(value):
		if flood_start != value:
			flood_start = value
			if flood_start == true:
				%FloodTimer.start()
			else:
				%FloodTimer.stop()
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var flood_spawner = preload("res://Object/Flood/flood_spawner.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.is_raining.connect(_is_raining)
	#spawn_flood()
func spawn_flood()-> void:
	var flood_spawn_instanciate = flood_spawner.instantiate()
	flood_spawn_instanciate.position = Vector3(rng.randf_range(minimum_pos_x,maximum_pos_x),0,rng.randf_range(minimum_pos_y,maximum_pos_y))
	add_child(flood_spawn_instanciate)
	Archivement.validate_archivement(9)
func _is_raining(value: bool)-> void:
	#%FloodTimer.start()
	flood_start = value
	%FloodTimer.wait_time = get_parent().flooding_wait_time
func _on_flood_timer_timeout() -> void:
	spawn_flood()
	if flood_start == true:
		%FloodTimer.start()
