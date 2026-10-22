extends Node3D

var can_delete: bool = false
func _ready() -> void:
	%AnimationPlayer.play("flooded")

func _on_timer_disepear_timeout() -> void:
	can_delete = true
	%AnimationPlayer.play_backwards("flooded")
	


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if can_delete == true:
		queue_free()
