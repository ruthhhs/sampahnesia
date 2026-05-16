extends Marker3D
@onready var overlapping_area_3d:Area3D = $CollidingCheckers
@export var bangunan: Node3D
@export var listrik: Node3D
@export var tumbuhan: Node3D

@export
var active_list: String = "bangunan list"
var id_input: int
var type_building_input: String = "bangunan"
var input_price: int
var popup_text = preload("res://UI/Prefabs/PopupText/popup_text.tscn")
var prefabs_list_lengkap = [
	preload("res://Object/Bangunan/Pertanian/Pertanian.tscn"),
	preload("res://Object/Bangunan/Peternakan/Peternakan.tscn"),
	preload("res://Object/Bangunan/PengolahanKayu/Pengolahan_kayu.tscn"),
	preload("res://Object/Bangunan/PlasticBag/Plastic_bag.tscn"),
	preload("res://Object/Bangunan/Butcher/butcher.tscn"),
	preload("res://Object/Bangunan/Kertas/Kertas.tscn"),
	preload("res://Object/Bangunan/PeleburanBijiPlastik/Peleburan_biji_plastik.tscn"),
	preload("res://Object/Bangunan/Pengalengan/Pengalengan.tscn"),
	preload("res://Object/Bangunan/GlassCup/Glass_cup.tscn"),
	preload("res://Object/Bangunan/Buku/buku.tscn"),
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
var index_selected: int=0
var can_place: bool = true
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_build") and can_place and not Global.currently_are_selecting:
		if overlapping_area_3d.get_overlapping_areas().size() <= 0:
			if id_input != null and type_building_input != null:
				if Global.stat_money >= input_price:
					Global.stat_money -= input_price
					spawning_from_node(id_input,type_building_input)
				else:
					var popup_text_instanciate = popup_text.instantiate()
					popup_text_instanciate.text = str("UANG TIDAK CUKUP!!!")
					%GameUIBuilder.add_child(popup_text_instanciate)
					

func spawning_from_node(id: int, type_building:String)-> void:
	var instanciating_object = prefabs_list_lengkap[id].instantiate()
	if type_building == "bangunan":
		bangunan.add_child(instanciating_object)
	elif type_building == "listrik":
		listrik.add_child(instanciating_object)
	elif type_building == "tumbuhan":
		tumbuhan.add_child(instanciating_object)
	instanciating_object.global_position = global_position
func _on_item_list_tumbuhan_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	type_building_input = "tumbuhan"

func _on_item_list_bangunan_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	type_building_input = "bangunan"

func _on_item_list_listrik_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	type_building_input = "listrik"
