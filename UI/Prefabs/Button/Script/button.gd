extends Button

func _on_pressed() -> void:
	$ClickAudioButton.play()

func _on_mouse_entered() -> void:
	$HoverAudioButton.play()
