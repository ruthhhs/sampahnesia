extends Label

@export var speed_move: float = 12.0
@export var speed_anim: float = 0.5

func _ready() -> void:
	$AnimationPlayer.speed_scale = speed_anim
	$AnimationPlayer.play("fade")
	
	pivot_offset = size/2
	position.y = $Control.global_position.y
	position.x = $Control.global_position.x-(size.x/2)+20
func _process(delta: float) -> void:
	position.y -= speed_move

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
