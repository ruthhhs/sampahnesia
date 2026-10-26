extends Control

@export var play_address: String 
@onready var setting: Control = $Setting
func _ready() -> void:
	Global.reset_game_data()
func _on_play_pressed() -> void:
	#print("bisa")
	Transition.change_scnee("res://UI/Scnee/Cutscnee/cutscene.tscn")
	#get_tree().change_scene_to_file(play_address)
	


func _on_setting_pressed() -> void:
	if setting.visible == false:
		setting.visible =  true
	else:
		setting.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()
