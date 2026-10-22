extends Marker3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer3D.play()




func _on_gpu_particles_3d_finished() -> void:
	queue_free()
