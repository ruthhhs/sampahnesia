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
func _ready() -> void:
	# Hubungkan signal dari Global script

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
	Global.first_building_damage_signal.connect(_on_first_bangunan_rusak)

func _on_start_timeout() -> void:
	if tutorial_awal != null:
		tutorial_awal.visible = true


# ==========================================
# Callback Signal dari Global Script
# ==========================================
func _on_first_sampah(is_connected_1: bool) -> void:
	if is_connected_1 and tutorial_sambung_pertanian != null:
		tutorial_sambung_pertanian.visible = true


func _on_first_pertanian(is_connected_2: bool) -> void:
	if is_connected_2 and tutorial_sambung_peternakan != null:
		tutorial_sambung_peternakan.visible = true


func _on_first_peternakan(is_connected_3: bool) -> void:
	if is_connected_3 and tutorial_sambung_peternakan != null:
		tutorial_sambung_peternakan.visible = true


func _on_first_toko(is_connected_4: bool) -> void:
	if is_connected_4 and tutorial_sambung_toko != null:
		tutorial_sambung_toko.visible = true

func _on_first_nebang(is_connected_5: bool) -> void:
	if is_connected_5 and tutorial_sambung_nebang != null:
		tutorial_sambung_nebang.visible = true

func _on_first_nanem(is_connected_6: bool) -> void:
	if is_connected_6 and tutorial_nanam_pohon != null:
		tutorial_nanam_pohon.visible = true

func _on_first_sampah_double_linked(is_connected_7: bool)-> void:
	if is_connected_7 and tutorial_double_linked_sampah != null:
		tutorial_double_linked_sampah.visible = true

func _on_first_bangunan_double_linked(is_connected_8: bool) ->void:
	if is_connected_8 and tutorial_double_linked_bangunan != null:
		tutorial_double_linked_bangunan.visible = true

func _on_first_bangunan_double_input(is_connected_9: bool)-> void:
	if is_connected_9 and tutorial_double_input_bangunan != null:
		tutorial_double_input_bangunan.visible = true

func _on_first_raycast_destroy(is_connected_10: bool) -> void:
	if is_connected_10 and tutorial_destroy_raycast != null:
		tutorial_destroy_raycast.visible = true
func _on_first_bangunan_rusak(is_connnected_11: bool) -> void:
	if is_connnected_11 and event_banjir != null:
		event_banjir.visible = true
