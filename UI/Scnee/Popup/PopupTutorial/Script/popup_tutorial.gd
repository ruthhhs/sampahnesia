extends Control

@export var image_information: CompressedTexture2D 
@export var text: String
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
