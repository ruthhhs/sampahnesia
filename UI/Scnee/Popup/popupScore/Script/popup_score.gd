extends Control


@export var next_level: String

func _ready() -> void:
	%PollutionBar.max_value = Transition.oksigen + Transition.karbon_dioksida
	%PollutionBar.value = Transition.oksigen
	#print(Transition.karbon_dioksida)
	%MoneyLabel.text = str(Global.stat_money)
func _on_button_pressed() -> void:
	visible = false

func _on_visibility_changed() -> void:
	if visible == false:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_next_pressed() -> void:
	%Fade.play("Transition")
	%Label.visible = true


func _on_fade_animation_finished(anim_name: StringName) -> void:
	Transition.change_scnee(next_level)
