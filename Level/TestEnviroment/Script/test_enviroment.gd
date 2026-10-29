extends Node3D

# Jumlah flood eksak per musim hujan, diatur oleh tier polusi
var flood_per_season: int = 1

var jumlah_sampah_terpanggil: int = 0
var maximum_sampah: int = 15
var nilai_pohon_default: int

@onready var pollution_bar: ProgressBar = $CameraPosition/CanvasLayer/GameUIBuilder/CityStatsRight/VBoxContainer/HBoxContainer/PollutionBar

# 1. Pisahkan nilai oksigen untuk pohon default (5) dan pohon baru (20)
@export var udara_pohon_default: int = 5
@export var udara_pohon_tanam: int = 20

# Asumsi node Sampah_added ada di dalam scene utama sebagai child node
@onready var sampah_added_node = $Sampah_added 

func _ready() -> void:
	nilai_pohon_default = $StarterNature.get_child_count()
	var mouse_object_follower: Marker3D = $CameraPosition/MouseFollowerObject
	mouse_object_follower.bangunan = $Bangunan
	mouse_object_follower.listrik = $Listrik
	mouse_object_follower.tumbuhan = $Nature
	$Island/AnimationPlayer.play("scneery")
	$CameraPosition.send_month.connect(adding_sampah)
	
	# Hitung oksigen awal menggunakan nilai 'udara_pohon_default'
	Global.stat_oxigen += udara_pohon_default * $StarterNature.get_child_count()
	update_polution_bar()

func adding_sampah(_month: int) -> void:
	var sampah_aktif = 0
	if sampah_added_node and sampah_added_node.target_spawn != null:
		sampah_aktif = sampah_added_node.target_spawn.get_child_count()
		
	var sisa_kuota = maximum_sampah - sampah_aktif
	
	if sisa_kuota <= 0:
		return

	var sampah_tambah = min(jumlah_sampah_terpanggil, sisa_kuota)
	
	if sampah_tambah > 0:
		sampah_added_node.antrian_sampah = sampah_tambah

# --- POHON YANG DITANAM PEMAIN (Gunakan udara_pohon_tanam = 20) ---
func _on_nature_child_entered_tree(_node: Node) -> void:
	Global.stat_oxigen += udara_pohon_tanam
	update_polution_bar()

func _on_nature_child_exiting_tree(_node: Node) -> void:
	Global.stat_oxigen -= udara_pohon_tanam
	update_polution_bar()

# --- POHON BAWAAN/DEFAULT MAP (Gunakan udara_pohon_default = 5) ---
func _on_starter_nature_child_exiting_tree(_node: Node) -> void:
	Global.stat_oxigen -= udara_pohon_default
	if nilai_pohon_default - $StarterNature.get_child_count() >= 2:
		Global.first_nebang_pohon = true
	update_polution_bar()    

# --- BANGUNAN & SAMPAH ---
func _on_bangunan_child_entered_tree(node: Node) -> void:
	Global.stat_polution += node.jumlah_polusi
	update_polution_bar()

func _on_bangunan_child_exiting_tree(node: Node) -> void:
	Global.stat_polution -= node.jumlah_polusi
	update_polution_bar()

func _on_sampah_child_entered_tree(node: Node) -> void:
	Global.stat_polution += node.jumlah_polusi
	update_polution_bar()

func _on_sampah_child_exiting_tree(node: Node) -> void:
	Global.stat_polution -= node.jumlah_polusi
	update_polution_bar()

func update_polution_bar() -> void:
	if not is_inside_tree() or pollution_bar == null:
		return
		
	var max_fog_density: float = 0.01
	var fog_dense_value: float 
	
	pollution_bar.max_value = Global.stat_oxigen + Global.stat_polution
	pollution_bar.value = Global.stat_oxigen
	fog_dense_value = remap(Global.stat_polution, 0.0, pollution_bar.max_value, 0.0, max_fog_density)
	
	var target_fog_density: float = 0.0
	
	# Makin kotor = makin banyak flood per musim hujan (angka eksak)
	if fog_dense_value < max_fog_density * 0.2:
		target_fog_density = max_fog_density * 0.0
		jumlah_sampah_terpanggil = 2
		flood_per_season = 3
		Archivement.validate_archivement(11)
		Global.ending_id = 0
	elif fog_dense_value < max_fog_density * 0.4:
		target_fog_density = max_fog_density * 0.2
		jumlah_sampah_terpanggil = 3
		flood_per_season = 5
		Global.ending_id = 0
	elif fog_dense_value < max_fog_density * 0.6:
		target_fog_density = max_fog_density * 0.6
		jumlah_sampah_terpanggil = 3
		flood_per_season = 8
		Global.ending_id = 1
	elif fog_dense_value < max_fog_density * 0.8:
		target_fog_density = max_fog_density * 0.8
		jumlah_sampah_terpanggil = 4
		flood_per_season = 10
		Global.ending_id = 2
	elif fog_dense_value <= max_fog_density * 1.0:
		target_fog_density = max_fog_density * 1.0
		jumlah_sampah_terpanggil = 5
		flood_per_season = 12
		Global.ending_id = 2
	else:
		return

	terapkan_transisi_fog(target_fog_density)

func terapkan_transisi_fog(target_value: float) -> void:
	if %WorldEnvironment.environment == null:
		return
		
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		%WorldEnvironment.environment, 
		"fog_density", 
		target_value, 
		0.5
	)
