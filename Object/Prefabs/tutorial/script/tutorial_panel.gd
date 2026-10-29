extends Control

@export var quest_added:PanelContainer
@export var quest_delisted: PanelContainer
@export var dialog: Array[String]
@export var highlight_target: Array[Control]
@export var seconds_per_char: float = 0.03

@export var delay_after_text: float = 1.5


@onready var dialog_label: RichTextLabel = $Tutorial/PanelDialog/DialogLabel

@onready var start_conversation: AnimationPlayer = $Tutorial/Sekertaris/conversation

@onready var highlight_panel: PackedScene = preload("res://Object/Prefabs/tutorial/highlight.tscn")

@onready var typing_sfx: AudioStreamPlayer = $TypingSFX



var current_dialog: int = 0

var active_highlight: Node = null

var text_tween: Tween

var is_text_finished: bool = false



func _ready() -> void:
	visible = false
	set_anchors_preset(Control.PRESET_FULL_RECT)

	

	if is_instance_valid(dialog_label):

		dialog_label.bbcode_enabled = true



func _input(event: InputEvent) -> void:

	if not visible:

		return

		

	var is_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed

	var is_action = Input.is_action_just_pressed("ui_accept")

	

	if is_click or is_action:

		# Hentikan event input agar tidak bocor ke objek 3D di bawahnya

		get_viewport().set_input_as_handled()

		handle_player_input()



func handle_player_input() -> void:

	if text_tween and text_tween.is_running():

		text_tween.kill()

		_stop_typing_sfx()

		if is_instance_valid(dialog_label):

			dialog_label.visible_ratio = 1.0

		is_text_finished = true

	elif is_text_finished:

		is_text_finished = false

		start_show_dialog()



func start_show_dialog() -> void:
	if quest_delisted != null:
		quest_delisted._deactivate()
	#if quest_added != null:
		#quest_added._activate()
	#if quest_delisted != null:
		#quest_delisted._deactivate()
	is_text_finished = false
#func _activate()-> void:
	#$QuestAnim.play("added")
	#
#func _deactivate() -> void:
	#$QuestAnim.play("delisted")
	

	if current_dialog == 0:

		var was_already_on_tutorial := Global.is_on_tutorial

		Global.register_tutorial(self)


		if is_instance_valid(start_conversation):

			if was_already_on_tutorial:

				start_conversation.play("stay_still")

			else:

				start_conversation.play("start_conversation")

	else:

		Global.register_tutorial(self)


	if is_instance_valid(active_highlight):

		active_highlight.queue_free()


	if current_dialog < dialog.size():

		var text_to_show := dialog[current_dialog]

		if is_instance_valid(dialog_label):

			dialog_label.text = text_to_show

			_reveal_text_dynamic(text_to_show)


		if current_dialog < highlight_target.size():

			var target = highlight_target[current_dialog]

			if is_instance_valid(target):

				if highlight_panel != null:

					active_highlight = highlight_panel.instantiate()

					target.add_child(active_highlight)

				else:

					push_error("Tutorial Panel Error: highlight_panel gagal di-load!")


		current_dialog += 1

	else:

		_finish_tutorial()



func _reveal_text_dynamic(_text: String) -> void:

	if text_tween and text_tween.is_running():

		text_tween.kill()


	if not is_instance_valid(dialog_label):

		return


	dialog_label.visible_ratio = 0.0

	

	var clean_text_length: int = dialog_label.get_parsed_text().length()

	var duration: float = clean_text_length * seconds_per_char


	if is_instance_valid(typing_sfx) and typing_sfx.stream:

		typing_sfx.play()


	text_tween = create_tween()

	text_tween.tween_property(dialog_label, "visible_ratio", 1.0, duration)

	text_tween.tween_callback(_stop_typing_sfx)

	text_tween.finished.connect(_on_text_reveal_finished)



func _stop_typing_sfx() -> void:

	if is_instance_valid(typing_sfx) and typing_sfx.playing:

		typing_sfx.stop()



func _on_text_reveal_finished() -> void:

	is_text_finished = true
	



func _finish_tutorial() -> void:

	_stop_typing_sfx()

	Global.unregister_tutorial(self)

	

	if is_instance_valid(start_conversation) and start_conversation.has_animation("start_conversation"):

		start_conversation.play_backwards("start_conversation")

		await start_conversation.animation_finished

	if quest_added != null:
		quest_added._activate()

	queue_free()



func _force_delete() -> void:

	if quest_added != null:
		quest_added._activate()
	_stop_typing_sfx()

	if is_instance_valid(active_highlight):

		active_highlight.queue_free()

	if text_tween and text_tween.is_running():

		text_tween.kill()

	queue_free()



func _on_visibility_changed() -> void:

	if visible:

		if not is_node_ready():

			await ready

		start_show_dialog() 
