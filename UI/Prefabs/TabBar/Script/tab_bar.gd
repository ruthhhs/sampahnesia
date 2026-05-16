extends TabBar

func _on_mouse_entered() -> void:
	$HoverAudioButton.play()
	print("it works also")

func _on_focus_entered() -> void:
	$ClickAudioButton.play()
	print("it work")
