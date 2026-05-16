extends CanvasLayer

func change_scnee(target: String)-> void:
	$AnimationPlayer.play("Transition")
	$AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("Transition")
