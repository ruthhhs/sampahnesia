extends Control
@onready var harga_tidak_cukup = preload("res://UI/Prefabs/PopupText/popup_text.tscn")

@export var harga_reparasi: int = 100
@export var id_minigame: int = 2

# diisi oleh Building sebelum popup di-add_child
var destroy_timer_node_insert: Node3D
var is_on_payment: bool = false

func _ready() -> void:
	%IsiText.text = str("Perbaikan bangunan membutuhkan $", harga_reparasi, ". Apakah kamu setuju dengan tawaran ini? ")
	%PopupAnim.play("show")

func _on_tidak_setuju_pressed() -> void:
	%PopupAnim.play("close")

func _on_setuju_pressed() -> void:
	# timer bisa saja sudah habis (bangunan hancur) saat popup masih terbuka
	if not is_instance_valid(destroy_timer_node_insert):
		queue_free()
		return

	if Global.stat_money >= harga_reparasi:
		Global.stat_money -= harga_reparasi
		%PopupAnim.play("close")
		is_on_payment = true
	else:
		var viewport_size = get_viewport().get_visible_rect().size
		var spawn_harga_tidak_cukup_position: Vector2 = Vector2(viewport_size.x / 2, viewport_size.y - 100)

		var harga_tidak_cukup_instance = harga_tidak_cukup.instantiate()
		harga_tidak_cukup_instance.global_position = spawn_harga_tidak_cukup_position
		harga_tidak_cukup_instance.text = str("Uang tidak mencukupi")
		add_child(harga_tidak_cukup_instance)

func _on_popup_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name != "close":
		return
	if is_on_payment and is_instance_valid(destroy_timer_node_insert):
		var path_minigame: String = str("res://Object/Prefabs/DestroyTimer/Minigame/Game", id_minigame, "/Minigame", id_minigame, ".tscn")
		var minigame = load(path_minigame)
		var minigame_instance = minigame.instantiate()
		# KONEKSI UTAMA: kirim referensi timer ke minigame SEBELUM add_child
		if "destroy_timer_node_insert" in minigame_instance:
			minigame_instance.destroy_timer_node_insert = destroy_timer_node_insert
		else:
			push_warning("Root minigame belum memakai script minigame_repairement.gd")

		destroy_timer_node_insert.repair_in_progress = true
		get_tree().root.add_child(minigame_instance)
		Archivement.validate_archivement(10)
		

	queue_free()
