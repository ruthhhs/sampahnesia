extends Control




func _on_button_pressed() -> void:
	if %LineEdit.text != "":
		Global.name_city = %LineEdit.text
		Transition.change_scnee("res://UI/Scnee/Cutscnee/cutscnee.tscn")
