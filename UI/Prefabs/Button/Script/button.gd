extends Button
@export var hover_information: Control
func _ready() -> void:
	if hover_information != null:
		hover_information.visible = false
func _on_pressed() -> void :
	$ClickAudioButton.play()

func _on_mouse_entered() -> void:
	$HoverAudioButton.play()
	if hover_information != null:
		hover_information.visible = true
		


func _on_mouse_exited() -> void:
	if hover_information != null:
		hover_information.visible = false
