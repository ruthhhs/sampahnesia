extends Control
@export var dialog: Array[String]
@export var highlight_target: Array[Control]
@export var seconds_per_char: float = 0.03
@export var delay_after_text: float = 1.5

@onready var dialog_label: Label = $Tutorial/PanelDialog/DialogLabel
@onready var start_conversation: AnimationPlayer = $Tutorial/Sekertaris/conversation
@onready var highlight_panel := preload("res://Object/Prefabs/tutorial/highlight.tscn")
@onready var typing_sfx: AudioStreamPlayer = $TypingSFX # Node suara ketikan

var current_dialog: int = 0
var active_highlight: Node = null
var text_tween: Tween


func _ready() -> void:
	# Memastikan UI selalu berada di depan layar dan memenuhi screen
	set_anchors_preset(Control.PRESET_FULL_RECT)


func start_show_dialog() -> void:
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

		# Pengecekan keamanan ekstra untuk highlight target
		if current_dialog < highlight_target.size():
			var target = highlight_target[current_dialog]
			if is_instance_valid(target):
				active_highlight = highlight_panel.instantiate()
				target.add_child(active_highlight)

		current_dialog += 1
	else:
		_finish_tutorial()


func _reveal_text_dynamic(text: String) -> void:
	if text_tween and text_tween.is_running():
		text_tween.kill()

	if not is_instance_valid(dialog_label):
		return

	dialog_label.visible_ratio = 0.0
	var duration: float = text.length() * seconds_per_char

	if is_instance_valid(typing_sfx) and typing_sfx.stream:
		typing_sfx.play()

	text_tween = create_tween()
	text_tween.tween_property(dialog_label, "visible_ratio", 1.0, duration)
	text_tween.tween_callback(_stop_typing_sfx)
	text_tween.tween_interval(delay_after_text)
	text_tween.finished.connect(_on_text_reveal_finished)


func _stop_typing_sfx() -> void:
	if is_instance_valid(typing_sfx) and typing_sfx.playing:
		typing_sfx.stop()


func _on_text_reveal_finished() -> void:
	start_show_dialog()


func _finish_tutorial() -> void:
	_stop_typing_sfx()
	Global.unregister_tutorial(self)
	
	if is_instance_valid(start_conversation) and start_conversation.has_animation("start_conversation"):
		start_conversation.play_backwards("start_conversation")
		await start_conversation.animation_finished
	
	queue_free()


func _force_delete() -> void:
	print("WARNING: Tutorial dihapus paksa oleh instance lain!")
	_stop_typing_sfx()
	if is_instance_valid(active_highlight):
		active_highlight.queue_free()
	if text_tween and text_tween.is_running():
		text_tween.kill()
	queue_free()


func _on_visibility_changed() -> void:
	if visible:
		start_show_dialog()
