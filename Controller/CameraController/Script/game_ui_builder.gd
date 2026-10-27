extends Control

@export var tutorial_awal: Control
@export var tutorial_sambung_pertanian: Control
@export var tutorial_sambung_peternakan: Control
@export var tutorial_sambung_toko: Control
@export var tutorial_sambung_nebang: Control
@export var tutorial_nanam_pohon: Control
@export var tutorial_double_linked_sampah: Control
@export var tutorial_double_linked_bangunan: Control
@export var tutorial_double_input_bangunan: Control
@export var tutorial_destroy_raycast: Control
@export var event_banjir: Control

# Variabel untuk melacak urutan tutorial yang sedang aktif
var step_tutorial: int = 0

func _ready() -> void:
	Global.first_sampah_signal.connect(_on_first_sampah)
	Global.first_pertanian_signal.connect(_on_first_pertanian)
	Global.first_perternakan_signal.connect(_on_first_peternakan)
	Global.first_toko_signal.connect(_on_first_toko)
	Global.first_nebang_signal.connect(_on_first_nebang)
	Global.first_nanem_signal.connect(_on_first_nanem)
	Global.first_sampah_double_linked_signal.connect(_on_first_sampah_double_linked)
	Global.first_bangunan_double_linked_signal.connect(_on_first_bangunan_double_linked)
	Global.first_bangunan_double_input_signal.connect(_on_first_bangunan_double_input)
	Global.first_destroy_raycast_signal.connect(_on_first_raycast_destroy)
	
	# Signal event independen (tidak masuk urutan)
	Global.first_building_damage_signal.connect(_on_first_bangunan_rusak)


# Helper function untuk menyembunyikan semua UI tutorial dan menampilkan step aktif
func set_tutorial_step(next_step: int, node_ui: Control) -> void:
	step_tutorial = next_step
	sembunyikan_semua_tutorial()
	if node_ui != null:
		node_ui.visible = true


func sembunyikan_semua_tutorial() -> void:
	if tutorial_awal: tutorial_awal.visible = false
	if tutorial_sambung_pertanian: tutorial_sambung_pertanian.visible = false
	if tutorial_sambung_peternakan: tutorial_sambung_peternakan.visible = false
	if tutorial_sambung_toko: tutorial_sambung_toko.visible = false
	if tutorial_sambung_nebang: tutorial_sambung_nebang.visible = false
	if tutorial_nanam_pohon: tutorial_nanam_pohon.visible = false
	if tutorial_double_linked_sampah: tutorial_double_linked_sampah.visible = false
	if tutorial_double_linked_bangunan: tutorial_double_linked_bangunan.visible = false
	if tutorial_double_input_bangunan: tutorial_double_input_bangunan.visible = false
	if tutorial_destroy_raycast: tutorial_destroy_raycast.visible = false


# Step 0: Timeout Awal
func _on_start_timeout() -> void:
	if step_tutorial == 0:
		set_tutorial_step(1, tutorial_awal)


# Step 1 -> Step 2
func _on_first_sampah(status: bool) -> void:
	if status and step_tutorial == 1:
		set_tutorial_step(2, tutorial_sambung_pertanian)


# Step 2 -> Step 3
func _on_first_pertanian(status: bool) -> void:
	if status and step_tutorial == 2:
		set_tutorial_step(3, tutorial_sambung_peternakan)


# Step 3 -> Step 4
func _on_first_peternakan(status: bool) -> void:
	if status and step_tutorial == 3:
		set_tutorial_step(4, tutorial_sambung_toko)


# Step 4 -> Step 5
func _on_first_toko(status: bool) -> void:
	if status and step_tutorial == 4:
		set_tutorial_step(5, tutorial_sambung_nebang)


# Step 5 -> Step 6
func _on_first_nebang(status: bool) -> void:
	if status and step_tutorial == 5:
		set_tutorial_step(6, tutorial_nanam_pohon)


# Step 6 -> Step 7
func _on_first_nanem(status: bool) -> void:
	if status and step_tutorial == 6:
		set_tutorial_step(7, tutorial_double_linked_sampah)


# Step 7 -> Step 8
func _on_first_sampah_double_linked(status: bool) -> void:
	if status and step_tutorial == 7:
		set_tutorial_step(8, tutorial_double_linked_bangunan)


# Step 8 -> Step 9
func _on_first_bangunan_double_linked(status: bool) -> void:
	if status and step_tutorial == 8:
		set_tutorial_step(9, tutorial_double_input_bangunan)


# Step 9 -> Step 10
func _on_first_bangunan_double_input(status: bool) -> void:
	if status and step_tutorial == 9:
		set_tutorial_step(10, tutorial_destroy_raycast)


# Step 10: Selesai
func _on_first_raycast_destroy(status: bool) -> void:
	if status and step_tutorial == 10:
		step_tutorial = 11
		sembunyikan_semua_tutorial()


# ==========================================
# Event Bebas / Independen
# ==========================================
func _on_first_bangunan_rusak(status: bool) -> void:
	if status and event_banjir != null:
		event_banjir.visible = true
