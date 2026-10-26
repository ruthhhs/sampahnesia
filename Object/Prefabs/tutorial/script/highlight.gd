extends Panel

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	print("added")

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("fade-out")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
