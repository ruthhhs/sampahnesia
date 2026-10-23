extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.is_raining.connect(_is_raining)
	#Global.delete_change.connect(_on_delete_change)
func _is_raining(value: bool)-> void:
	emitting = value
	if value == true:
		emitting = true
		$RainSound.playing = true
		$AnimationPlayer.play("is_rain")
	else:
		emitting = false
		$AnimationPlayer.play("is_rain_backward")
	%RainingTime.start()



func _on_raining_time_timeout() -> void:
	#$AnimationPlayer.play("is_rain_backward")
	Global.currently_are_raining = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "is_rain_backward":
		$RainSound.playing = false
