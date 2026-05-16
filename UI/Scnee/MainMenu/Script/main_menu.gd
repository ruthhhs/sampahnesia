extends Control


@export var play_address: String 
@export var credits_address: String
@onready var setting: Control = $Setting

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(play_address)

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file(credits_address)

func _on_setting_pressed() -> void:
	if setting.visible == false:
		setting.visible =  true
	else:
		setting.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()
