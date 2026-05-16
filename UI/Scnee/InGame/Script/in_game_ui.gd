extends Control

func _ready() -> void:
	$Pause.visible = false
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		print($Pause.visible)
		if $Pause.visible == true:
			$Pause.visible = false
		else :
			$Pause.visible = true
		
