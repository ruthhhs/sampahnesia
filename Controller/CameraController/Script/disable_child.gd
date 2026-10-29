extends Node

@export var disable_child: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if disable_child == true:
		for i in range(get_child_count()):
			get_child(i).queue_free() 
