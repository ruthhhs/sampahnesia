extends Control

var archivement_title: StringName
var explain: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Button/HBoxContainer/VBoxContainer/Label.text = archivement_title
	$Button/HBoxContainer/VBoxContainer/RichTextLabel.text = explain
	$AnimationPlayer.play("popin")


func _on_fade_animation_finished(anim_name: StringName) -> void:
	queue_free()


func _on_timer_timeout() -> void:
	$Timer/fade.play("fade")
