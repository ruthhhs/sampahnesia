extends Marker3D

@onready var overlapping_area_3d: Area3D = $CollidingCheckers

@export var bangunan: Node3D
@export var listrik: Node3D
@export var tumbuhan: Node3D

@export var id_input: int
@export var type_building_input: String = "bangunan"
@export var input_price: int
@export var harga_eceran: int
@export var building_need_electicity: bool

var texture_input: CompressedTexture2D
var texture_output: CompressedTexture2D
var popup_text = preload("res://UI/Prefabs/PopupText/popup_text.tscn")

var prefabs_list_lengkap = [
	preload("res://Object/Bangunan/Pertanian/Pertanian.tscn"),
	preload("res://Object/Bangunan/Peternakan/Peternakan.tscn"),
	preload("res://Object/Bangunan/PengolahanKayu/Pengolahan_kayu.tscn"),
	preload("res://Object/Bangunan/PlasticBag/Plastic_bag.tscn"),
	preload("res://Object/Bangunan/Butcher/Butcher.tscn"),
	preload("res://Object/Bangunan/Kertas/Kertas.tscn"),
	preload("res://Object/Bangunan/PeleburanBijiPlastik/Peleburan_biji_plastik.tscn"),
	preload("res://Object/Bangunan/Pengalengan/Pengalengan.tscn"),
	preload("res://Object/Bangunan/GlassCup/Glass_cup.tscn"),
	preload("res://Object/Bangunan/Buku/Buku.tscn"),
	preload("res://Object/Bangunan/PlastikFurnitur/Plastik_furnitur.tscn"),
	preload("res://Object/Bangunan/Furnitur/Furnitur.tscn"),
	preload("res://Object/Bangunan/BijiKaca/Biji_kaca.tscn"),
	preload("res://Object/Bangunan/GlassBulb/Glass_bulb.tscn"),
	preload("res://Object/Bangunan/PralonPVC/Pralon_pvc.tscn"),
	preload("res://Object/Bangunan/Lamp/Lamp.tscn"),
	preload("res://Object/Bangunan/Silikon/Silicon.tscn"),
	preload("res://Object/Bangunan/Processor/Processor.tscn"),
	preload("res://Object/Bangunan/Computer/Computer.tscn"),
	preload("res://Object/Bangunan/SuperComputer/Super_computer.tscn"),
	preload("res://Object/ProduksiListrik/PembangkitListrikTenagaSampah/PembangkitListrikTenagaSampah.tscn"),
	preload("res://Object/ProduksiListrik/PembangkitListrikTenagaSurya/PembangkitListrikTenagaSurya.tscn"),
	preload("res://Object/ProduksiListrik/PembangkitListrikTenagaAngin/PembangkitListrikTenagaAngin.tscn"),
	preload("res://Object/ProduksiListrik/PembangkitListrikTenagaNuklir/PembangkitListrikTenagaNuklir.tscn"),
	preload("res://Object/Toko/TokoKecil/toko_kecil.tscn"),
	preload("res://Object/Toko/TokoBesar/toko_besar.tscn"),
	preload("res://Object/Pohon/pohon.tscn")
]

var index_selected: int = 0
var can_place: bool = true
var _is_spawning: bool = false  # Flag untuk mencegah klik ganda/double spawn

func _unhandled_input(event: InputEvent) -> void:
	# 1. Pastikan aksi build ditekan, tempat valid, tidak sedang _is_spawning, 
	# dan yang paling penting: Global.currently_are_selecting harus bernilai TRUE.
	if event.is_action_pressed("mouse_build") and can_place and not _is_spawning:
		
		# JIKA SEDANG TIDAK SELECTING, MAKA BATALKAN (RETURN)
		if not Global.currently_are_selecting:
			return
			
		print("Selecting: ", Global.currently_are_inspecting, "| Building: ", Global.currently_are_selecting, "| Deleting: ", Global.currently_are_delete)
		
		if not Global.currently_are_delete:
			if overlapping_area_3d.get_overlapping_areas().is_empty():
				if id_input != null and type_building_input != null:
					if Global.stat_money >= input_price:
						Global.stat_money -= input_price
						spawning_from_node(id_input, type_building_input)
					else:
						var popup_text_instanciate = popup_text.instantiate()
						popup_text_instanciate.text = "UANG TIDAK CUKUP!!!"
						if has_node("%GameUIBuilder"):
							%GameUIBuilder.add_child(popup_text_instanciate)
		else:
			if overlapping_area_3d.get_overlapping_areas().size() >= 1:
				if has_node("%DeleteAudio"):
					%DeleteAudio.play()

func spawning_from_node(id: int, type_building: String) -> void:
	# Cegah eksekusi ganda jika fungsi ini terpanggil bersamaan
	if _is_spawning:
		return
	_is_spawning = true
	
	# Validasi index array untuk menghindari crash Out of Bounds
	if id < 0 or id >= prefabs_list_lengkap.size():
		push_error("ID Prefab tidak valid atau di luar batas: " + str(id))
		_is_spawning = false
		return
		
	var instanciating_object = prefabs_list_lengkap[id].instantiate()
	
	if has_node("%BuildAudio"):
		%BuildAudio.play()
		
	match type_building:
		"bangunan":
			if bangunan:
				bangunan.add_child(instanciating_object)
			instanciating_object.input_texture = texture_input
			instanciating_object.output_texture = texture_output
			if instanciating_object.has_method("change_input_output_texture"):
				instanciating_object.change_input_output_texture()
			instanciating_object.is_electric_usage = building_need_electicity
			instanciating_object.simpan_harga_bangunan = input_price
			if "can_sell" in instanciating_object and instanciating_object.can_sell:
				instanciating_object.price = harga_eceran
				
		"listrik":
			if listrik:
				listrik.add_child(instanciating_object)
				
		"tumbuhan":
			if tumbuhan:
				tumbuhan.add_child(instanciating_object)
				
	instanciating_object.global_position = global_position
	
	# Lepaskan kunci flag agar bisa membangun lagi
	_is_spawning = false


func _on_tab_container_tab_changed(tab: int) -> void:
	match tab:
		0:
			type_building_input = "bangunan"
		1:
			type_building_input = "listrik"
		2:
			type_building_input = "bangunan"
		3:
			type_building_input = "tumbuhan"
