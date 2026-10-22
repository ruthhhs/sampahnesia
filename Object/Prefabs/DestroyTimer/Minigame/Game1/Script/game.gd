extends Node2D

var selected_color: Color
var maximum_position: Vector2
var minimum_position: Vector2
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var waiting_for_connecting: bool
var color_input: Array[Color]
var color_output:Array[Color]
@onready var input_playable: Node2D = $Input
@onready var output_playable: Node2D = $Output
@onready var playable_area: Area2D = $PlayableArea
@onready var collision_playable:CollisionShape2D = $PlayableArea/CollusionPlayableArea
@onready var output_marker := preload("res://Object/Prefabs/DestroyTimer/Minigame/Game1/output_marker.tscn")
@onready var input_marker := preload("res://Object/Prefabs/DestroyTimer/Minigame/Game1/input_marker.tscn")
@export var color_connector: Array[Color]
var unfinished_processed: int = 3:
	set(value):
		if unfinished_processed != value:
			unfinished_processed = value
			if unfinished_processed <= 0:
				print("selesai")
				get_parent().get_parent().is_complete = true
func _ready() -> void:
	unfinished_processed = input_playable.get_child_count()
	color_input.resize(color_connector.size())
	color_output.resize(color_connector.size())
	color_connector.shuffle()
	
	#spawn input
	for i in range(color_input.size()):
		color_input[i] = color_connector[i] 
	for i in range(color_input.size()):
		added(input_marker,input_playable.get_child(i))
		input_playable.get_child(i).get_child(0).get_child(0).default_color = color_input[i]
		input_playable.get_child(i).get_child(0).get_child(1).default_color = color_input[i]
	
	#spawn output
	color_connector.shuffle()
	for i in range(color_output.size()):
		color_output[i]=color_connector[i]
	for i in range(color_output.size()):
		added(output_marker,output_playable.get_child(i))
		output_playable.get_child(i).get_child(0).get_child(0).default_color = color_output[i]
	
# connecting (diperbaiki)
	for i in range(color_input.size()):
		for j in range(color_output.size()):
			# Jika warna input pada indeks i sama dengan warna output pada indeks j
			if color_input[i] == color_output[j]:
				# Set target_area menggunakan indeks j untuk output
				input_playable.get_child(i).get_child(0).target_area = output_playable.get_child(j).get_child(0).get_child(1)
				break # Keluar dari perulangan j jika sudah ketemu pasangannya
func added(preloading,child_target: Marker2D)-> void:
	var preloading_instanciate = preloading.instantiate()
	child_target.add_child(preloading_instanciate)

func _process(delta: float) -> void:
	var center_pos = get_parent().size/2
	collision_playable.shape.size = get_parent().get_parent().size
	playable_area.position = center_pos
	input_playable.position = center_pos
	output_playable.position = center_pos
	
	
