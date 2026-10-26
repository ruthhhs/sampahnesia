extends Control

@export var level_1: String
@export var dialog_array: Array[String] # panjang array sama
@export var speaker_name: Array[String] # panjang array sama
var dialog_count: int
var is_transitioning: bool = true

# MULAI #
func _ready() -> void:
	$AnimationPlayer.play("fade-in")
	await $AnimationPlayer.animation_finished
	%"skip-btn".show()
	%"next-btn".show()
	start_cutscene()
	
func start_cutscene() -> void:
	play_sound()
	change_dialog()
	is_transitioning = false

# GANTI TEKS #
func _input(event: InputEvent) -> void: 
	if Input.is_action_just_pressed("ui_accept"): # spasi
		condition_change_dialog() 
	if event is InputEventMouseButton: # klik kiri
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			condition_change_dialog()

func change_dialog() -> void:    
	if dialog_count < dialog_array.size():
		%Nama.text = str(speaker_name[dialog_count])
		%Dialog.text = str(dialog_array[dialog_count])
		
		# --- CEK PEMBICARA & PLAY ANIMASI ---
		var current_speaker: String = speaker_name[dialog_count]
		var prev_speaker: String = speaker_name[dialog_count - 1] if dialog_count > 0 else ""

		if current_speaker != prev_speaker:
			match current_speaker:
				"Pemain":
					$DialogControl/walikota/AnimasiWalikota.play("is_on_walikota")
					$DialogControl/sekretaris/AnimasiSekertaris.play_backwards("is_on_sekertaris")
				"Sekretaris":
					$DialogControl/sekretaris/AnimasiSekertaris.play("is_on_sekertaris")
					$DialogControl/walikota/AnimasiWalikota.play_backwards("is_on_walikota")
				_: # Untuk narator/monolog ("-")
					$DialogControl/walikota/AnimasiWalikota.play_backwards("is_on_walikota")
					$DialogControl/sekretaris/AnimasiSekertaris.play_backwards("is_on_sekertaris")

		# --- ANIMASI SUARA / EFEK TEKS ---
		match %Nama.text:
			"Pemain":
				$AnimationPlayer.play("walikota_speak")

			"Sekretaris":
				$AnimationPlayer.play("sekretaris_speak")

			"-":
				$AnimationPlayer.play("typing")
		
		dialog_count += 1
	else:
		selesai()

# KONDISI #
func condition_change_dialog() -> void:
	if is_transitioning:
		return

	if %Dialog.visible_ratio < 1.0:
		$AnimationPlayer.seek(
			$AnimationPlayer.current_animation_length)
		$TypingSFX.stop()
		$TypingTimer.stop()
	else:
		play_sound()
		change_dialog()
	
	if dialog_count == 4:
		%Dialog.hide()
		transisi_mono_dia() 

func transisi_mono_dia() -> void:
	$TypingSFX.stop()
	is_transitioning = true
	
	$AnimationPlayer.play("fade-out")
	await $AnimationPlayer.animation_finished
	%"BG-monolog".hide()
	%"BG-vignette-mono".hide()
	%"BG-dialog".show()
	%"BG-vignett-dia".show()
	
	$AnimationPlayer.play("fade-in")
	await $AnimationPlayer.animation_finished
	%DialogControl.show()
	
	%Dialog.position = Vector2(155, 828)
	%Dialog.modulate = Color("#032731")
	%Dialog.add_theme_font_size_override("normal_font_size", 32)
	%Dialog.show()
	
	start_cutscene()

# SUARA #
func play_sound() -> void:
	$TypingSFX.play()
	$TypingTimer.start(2.0)

func _on_typing_timer_timeout():
	$TypingSFX.stop()

# SELESAI #
func _on_button_pressed() -> void:
	selesai()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	selesai()
	
func selesai() -> void:
	%"skip-btn".hide()
	%"next-btn".hide()
	$TypingSFX.stop()
	is_transitioning = true

	Transition.change_scnee(level_1)
