extends Control

@export var array_color: Array[Color]
@onready var panel_sliding:= preload("res://Object/Prefabs/DestroyTimer/Minigame/Game4/panel_siding.tscn")
@onready var control_panel = $ControlPanel

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var value_array: Array[float]
var count_down_win: int = 1:
	set(value):
		if count_down_win != value:
			count_down_win = value
			print(count_down_win)
			if value <= 0:
				get_parent().get_parent().is_complete = true

func _ready() -> void:
	count_down_win = array_color.size()
	value_array.resize(array_color.size())
	array_color.shuffle()
	#insiate
	for i in range(value_array.size()):
		value_array[i] = randf_range(25.0, 100.0)
		added_panel_slider(control_panel,value_array[i], array_color[i])
func _input(event: InputEvent) -> void:
	pass
func added_panel_slider(parent: HBoxContainer, insert_value: float,color: Color)-> void:
	var panel_slide_instanciate = panel_sliding.instantiate()
	panel_slide_instanciate.value = insert_value
	panel_slide_instanciate.modulate = color
	parent.add_child(panel_slide_instanciate)
