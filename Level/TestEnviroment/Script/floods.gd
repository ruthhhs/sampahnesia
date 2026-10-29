extends Node3D

@export var maximum_pos_x: float = 204.249
@export var minimum_pos_x: float = -211.055
@export var maximum_pos_y: float = 157.79
@export var minimum_pos_y: float = -155.321

@export_group("Flood Count")
@export var spawn_delay: float = 1.0   # jeda antar spawn (detik)

var flood_spawned: int = 0
var flood_target: int = 0

var flood_start: bool = false:
	set(value):
		if flood_start != value:
			flood_start = value
			if flood_start:
				flood_spawned = 0
				# Target dikunci saat hujan mulai, diambil dari tier polusi di level
				flood_target = get_parent().flood_per_season
				%FloodTimer.wait_time = spawn_delay
				%FloodTimer.start()
			else:
				%FloodTimer.stop()

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var flood_spawner = preload("res://Object/Flood/flood_spawner.tscn")

func _ready() -> void:
	Global.is_raining.connect(_is_raining)

func spawn_flood() -> void:
	var flood_spawn_instanciate = flood_spawner.instantiate()
	flood_spawn_instanciate.position = Vector3(
		rng.randf_range(minimum_pos_x, maximum_pos_x),
		0,
		rng.randf_range(minimum_pos_y, maximum_pos_y)
	)
	add_child(flood_spawn_instanciate)
	flood_spawned += 1
	Archivement.validate_archivement(9)

func _is_raining(value: bool) -> void:
	flood_start = value

func _on_flood_timer_timeout() -> void:
	spawn_flood()
	if flood_spawned >= flood_target:
		flood_start = false   # target tercapai, timer berhenti
	else:
		%FloodTimer.start()
