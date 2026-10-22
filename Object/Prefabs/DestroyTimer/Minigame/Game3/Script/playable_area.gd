extends Area2D
var maximum_position: Vector2
var minimum_position: Vector2
@onready var collision_playable:CollisionShape2D = $CollusionPlayableArea
func _process(delta: float) -> void:
	collision_playable.shape.size = get_parent().get_parent().size
	position = get_parent().get_parent().size/2
	
	
