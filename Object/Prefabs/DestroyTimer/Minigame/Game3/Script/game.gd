extends Node2D
@onready var playable_area: Area2D = $PlayableArea
@onready var collision_playable = $PlayableArea/CollusionPlayableArea
@onready var input_playable: Node2D = $Input
@onready var output_playable: Node2D = $Output
@onready var output_item:= preload("res://Object/Prefabs/DestroyTimer/Minigame/Game3/output_item.tscn")
@onready var input_item:= preload("res://Object/Prefabs/DestroyTimer/Minigame/Game3/input_item.tscn")
@export var texture_array: Array[CompressedTexture2D]
var id_array : Array[int]
var unfinished_processed: int :
	set(value):
		if unfinished_processed != value:
			unfinished_processed = value
			if unfinished_processed <= 0:
				print("selesai")
				get_parent().get_parent().is_complete = true
func _ready() -> void:
	unfinished_processed = texture_array.size()
	if texture_array.size() == input_playable.get_child_count() and texture_array.size() == output_playable.get_child_count():
		id_array.resize(texture_array.size())
		for i in range(id_array.size()):
			id_array[i] = i
		id_array.shuffle()
		
		for i in range(input_playable.get_child_count()):
			#input
			var item_input_instance = _added(input_playable.get_child(i), input_item)
			item_input_instance.input_texture = texture_array[id_array[i]]
			item_input_instance.id_object_input = id_array[i]
		id_array.shuffle()
		for i in range(output_playable.get_child_count()):
			#output
			var item_output_instance = _added(output_playable.get_child(i),output_item)
			item_output_instance.get_child(0).texture = texture_array[id_array[i]]
			item_output_instance.id_object_output = id_array[i]

func _added(parent: Node2D, type )-> Node:
	var type_item = type.instantiate()
	parent.add_child(type_item)
	return type_item

func _process(delta: float) -> void:
	var center_pos = get_parent().size/2
	collision_playable.shape.size = get_parent().get_parent().size
	playable_area.position = center_pos
	input_playable.position = center_pos
	output_playable.position = center_pos
	
	
