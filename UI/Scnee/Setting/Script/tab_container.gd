extends TabContainer

func _on_tab_hovered(_tab: int) -> void:
	$HoverAudioButton.play()

func _on_tab_clicked(_tab: int) -> void:
	$ClickAudioButton.play()
