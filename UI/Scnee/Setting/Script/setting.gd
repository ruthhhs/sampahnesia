extends Control

@onready var debugger_label: Label = $Debugger/Label

func _process(_delta: float) -> void:
	debugger_label.text = str(AudioServer.get_bus_volume_db(0)) 

func _on_exit_button_pressed() -> void:
	visible = false
func _on_visibility_changed() -> void:
	if visible == true:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
## Gameplay ##
func _on_mouse_sense_slider_value_changed(value: float) -> void:
	GlobalSetting.mouse_sense_value = value

func _on_fov_slider_value_changed(value: float) -> void:
	GlobalSetting.fov_value = value

func _on_fps_enabler_toggled(toggled_on: bool) -> void:
	GlobalSetting.fps_enable = toggled_on

## Video ##

func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	GlobalSetting.fullscreen_enable = toggled_on
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resolution_option_item_selected(index: int) -> void:
	GlobalSetting.resolution_index = index
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1440, 810))
		2:
			DisplayServer.window_set_size(Vector2i(800, 450))

## Audio ##

func _on_audio_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)
	GlobalSetting.master_value = value

func _on_audio_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	GlobalSetting.sfx_value = value

func _on_audio_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	GlobalSetting.music_value = value
