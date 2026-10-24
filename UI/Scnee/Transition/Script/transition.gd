extends CanvasLayer
var oksigen: int
var karbon_dioksida: int
func _ready() -> void:
	$AnimationPlayer.play_backwards("Transition")
func change_scnee(target: String)-> void:
	if target != null:
			
		$AnimationPlayer.play("Transition")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file(target)
		$AnimationPlayer.play_backwards("Transition")
