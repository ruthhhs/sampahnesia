extends Control
@export var tutorial_awal: Control
@export var tutorial_sambung_pertanian: Control
@export var tutorial_sambung_peternakan: Control
@export var tutorial_sambung_toko: Control
@export var tutorial_sambung_nebang: Control
@export var tutorial_nanam_pohon: Control
@export var tutorial_double_linked_sampah: Control
pass
func _ready() -> void:
	# Hubungkan signal dari Global script

	Global.first_sampah_signal.connect(_on_first_sampah)
	Global.first_pertanian_signal.connect(_on_first_pertanian)
	Global.first_perternakan_signal.connect(_on_first_peternakan)
	Global.first_toko_signal.connect(_on_first_toko)
	Global.first_nebang_signal.connect(_on_first_nebang)
	Global.first_nanem_signal.connect(_on_first_nanem)
	Global.first_sampah_double_linked_signal


func _on_start_timeout() -> void:
	if tutorial_awal != null:
		tutorial_awal.visible = true


# ==========================================
# Callback Signal dari Global Script
# ==========================================
func _on_first_sampah(is_connected: bool) -> void:
	if is_connected and tutorial_sambung_pertanian != null:
		tutorial_sambung_pertanian.visible = true


func _on_first_pertanian(is_connected: bool) -> void:
	if is_connected and tutorial_sambung_peternakan != null:
		tutorial_sambung_peternakan.visible = true


func _on_first_peternakan(is_connected: bool) -> void:
	if is_connected and tutorial_sambung_peternakan != null:
		tutorial_sambung_peternakan.visible = true


func _on_first_toko(is_connected: bool) -> void:
	if is_connected and tutorial_sambung_toko != null:
		tutorial_sambung_toko.visible = true

func _on_first_nebang(is_connected: bool) -> void:
	if is_connected and tutorial_sambung_nebang != null:
		tutorial_sambung_nebang.visible = true

func _on_first_nanem(is_connected: bool) -> void:
	if is_connected and tutorial_nanam_pohon != null:
		tutorial_nanam_pohon.visible = true
func _onfirst_sampah_double_linked_signal(is_connected: bool)-> void:
	if is_connected and tutorial_double_linked_sampah != null:
		tutorial_double_linked_sampah.visible = true
