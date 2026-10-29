extends VBoxContainer


func _on_timer_timeout() -> void:
	$MouseAnim.play("fade-out")


func _on_mouse_anim_animation_finished(_anim_name: StringName) -> void:
	queue_free()
