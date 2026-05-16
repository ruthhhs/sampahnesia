extends Control
func _on_resume_pressed() -> void:
	visible = false
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
func _on_setting_pressed() -> void:
	$Setting.visible = true
func _on_main_menu_pressed() -> void:
	Transition.change_scnee("res://UI/Scnee/MainMenu/main_menu.tscn")
func _on_visibility_changed() -> void:
	if visible == true:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
func _on_setting_visibility_changed() -> void:
	if $Setting.visible == true:
		$BG.visible = false
	else:
		$BG.visible = true
