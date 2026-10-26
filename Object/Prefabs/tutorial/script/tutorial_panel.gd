extends Control

@export var dialog: Array[String]
@export var highlight_target: Array[Control]
@export var seconds_per_char: float = 0.03
@export var delay_after_text: float = 1.5

# Ubah nodepath & tipe variabel ke RichTextLabel
@onready var dialog_label: RichTextLabel = $Tutorial/PanelDialog/DialogLabel
@onready var start_conversation: AnimationPlayer = $Tutorial/Sekertaris/conversation
@onready var highlight_panel: PackedScene = preload("res://Object/Prefabs/tutorial/highlight.tscn")
@onready var typing_sfx: AudioStreamPlayer = $TypingSFX # Node suara ketikan

var current_dialog: int = 0
var active_highlight: Node = null
var text_tween: Tween


func _ready() -> void:
	# Memastikan UI selalu berada di depan layar dan memenuhi screen
	set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Aktifkan BBCode secara terprogram untuk mendukung formatting teks ([b], [color], dll)
	if is_instance_valid(dialog_label):
		dialog_label.bbcode_enabled = true


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
		print("dialog: ", dialog[current_dialog])
		var text_to_show := dialog[current_dialog]
		if is_instance_valid(dialog_label):
			# Pada RichTextLabel, gunakan text atau text = text_to_show jika bbcode aktif
			dialog_label.text = text_to_show
			_reveal_text_dynamic(text_to_show)

		# Pengecekan keamanan untuk highlight target & highlight_panel
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

	# Reset animasi ketik RichTextLabel ke 0
	dialog_label.visible_ratio = 0.0
	
	# Untuk RichTextLabel, hitung panjang teks bersih (tanpa tag BBCode) agar durasi animasi pas
	var clean_text_length: int = dialog_label.get_parsed_text().length()
	var duration: float = clean_text_length * seconds_per_char

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
	#if Global.is_on_tutorial == true:
	if visible :
		if not is_node_ready():
			await ready
		start_show_dialog()
