extends Control

@export var image_information: Texture2D 
@export var text: String
@export var next_level: String
func _ready() -> void:
	$PanelContainer/VBoxContainer/TextureRect.texture = image_information
	$PanelContainer/VBoxContainer/Label.text = text
func _on_button_pressed() -> void:
	visible = false


func _on_visibility_changed() -> void:
	if visible == false:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_next_pressed() -> void:
	Transition.change_scnee(next_level)
