extends ProgressBar
@onready var audio_connect: AudioStreamOggVorbis = preload("res://UI/UIFX/kenney_interface-sounds/Audio/question_003.ogg")
@onready var audio_disconect:AudioStreamOggVorbis = preload("res://UI/UIFX/kenney_interface-sounds/Audio/question_004.ogg")
@onready var interact_value: VSlider = $InteractValue
var tolerate : float = 8.0
var is_connect: bool = false:
	set(value):
		if is_connect != value:
			is_connect = value
			if is_connect == true:
				get_parent().get_parent().count_down_win -= 1
			else:
				get_parent().get_parent().count_down_win += 1

func _on_interact_value_value_changed(_value: float) -> void:
	if value < interact_value.value + tolerate and value > interact_value.value - tolerate:
		pass
	#print("interact value + ", tolerate, " = ", interact_value.value + tolerate, " | interact value - ", tolerate, " = ", interact_value.value - tolerate, " || value = ", value)


func _on_interact_value_drag_ended(value_changed: bool) -> void:
	
	if value < interact_value.value + tolerate and value > interact_value.value - tolerate:
		$EfekAudio.stream = audio_connect
		is_connect = true
	else:
		$EfekAudio.stream = audio_disconect
		is_connect = false
	$EfekAudio.play()
