extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.currently_are_inspecting = true
	Global.currently_are_selecting = false
	Global.currently_are_delete = false
	$SelectMode.disabled = true
	$BuildMode.disabled = false
	$DeleteMode.disabled = false

func _on_select_mode_pressed() -> void:
	Global.currently_are_inspecting = true
	Global.currently_are_selecting = false
	Global.currently_are_delete = false
	$SelectMode.disabled = true
	$BuildMode.disabled = false
	$DeleteMode.disabled = false

func _on_build_mode_pressed() -> void:
	Global.currently_are_inspecting = false
	Global.currently_are_selecting = true
	Global.currently_are_delete = false

	$SelectMode.disabled = false
	$BuildMode.disabled = true
	$DeleteMode.disabled = false

func _on_delete_mode_pressed() -> void:
	
	Global.currently_are_inspecting = false
	Global.currently_are_selecting = false
	Global.currently_are_delete = true
	$SelectMode.disabled = false
	$BuildMode.disabled = false
	$DeleteMode.disabled = true
