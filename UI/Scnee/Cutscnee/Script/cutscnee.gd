extends Control

@export var level_1: String
func _ready() -> void:
	$AnimationPlayer.play("Cutscnee")

func _on_button_pressed() -> void:
	Transition.change_scnee(level_1)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Transition.change_scnee(level_1)
