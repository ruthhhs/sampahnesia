extends Marker3D

@onready var preview_object: MeshInstance3D = $Preview_object
@onready var overlapping_area_3d: Area3D = $CollidingCheckers
@export var tutorial: Control
@export var bangunan: Node3D
@export var listrik: Node3D
@export var tumbuhan: Node3D

# Preload Material Preview Valid (Hijau/Biru) & Invalid (Merah)
@onready var invalid_place_material = preload("res://Assets/Shaders/preview_building_disable.tres")
@onready var valid_place_material = preload("res://Assets/Shaders/preview_building_enable.tres")

# Set nilai default id_input ke -1 (menandakan belum ada pilihan/kosong)
@export var id_input: int = -1:
	set(value):
		id_input = value
		_update_spawner_collision_and_preview()
		_update_preview_visibility()

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

var can_place: bool = true
var _is_spawning: bool = false

func _ready() -> void:
	if overlapping_area_3d != null:
		overlapping_area_3d.input_event.connect(_on_colliding_checkers_input_event)
		# Hubungkan signal deteksi tabrakan area
		overlapping_area_3d.area_entered.connect(_on_colliding_area_changed)
		overlapping_area_3d.area_exited.connect(_on_colliding_area_changed)
	
	# Sambungkan signal untuk mengontrol tampil/sembunyinya preview
	Global.is_selecting.connect(_on_selecting_changed)
	Global.delete_change.connect(_on_delete_changed)
	
	_update_spawner_collision_and_preview()
	_update_preview_visibility()

# ===================================================
# LOGIKA DETEKSI TABRAKAN (VALID / INVALID MATERIAL)
# ===================================================
func _on_colliding_area_changed(_area: Area3D) -> void:
	_check_preview_placement_validity()

func _check_preview_placement_validity() -> void:
	if preview_object == null or overlapping_area_3d == null:
		return
		
	# Jika bertabrakan = Invalid (Disable), jika area kosong = Valid (Enable)
	if overlapping_area_3d.get_overlapping_areas().size() > 0:
		preview_object.material_override = invalid_place_material
	else:
		preview_object.material_override = valid_place_material

# ===================================================
# LOGIKA VISIBILITAS PREVIEW
# ===================================================
func _update_preview_visibility() -> void:
	if preview_object != null:
		var has_valid_item: bool = id_input >= 0 and id_input < prefabs_list_lengkap.size()
		preview_object.visible = Global.currently_are_selecting and not Global.currently_are_delete and has_valid_item
		
		# Selalu update status material saat visibilitas diperbarui
		if preview_object.visible:
			_check_preview_placement_validity()

func _on_selecting_changed(_is_selecting: bool) -> void:
	if _is_selecting:
		id_input = -1
	_update_preview_visibility()

func _on_delete_changed(_is_delete: bool) -> void:
	_update_preview_visibility()

# ===================================================
# FUNGSI DINAMIS BENTUK COLLISION & PREVIEW MESH
# ===================================================
func _update_spawner_collision_and_preview() -> void:
	if overlapping_area_3d == null:
		return
		
	var spawner_collision: CollisionShape3D = overlapping_area_3d.get_node_or_null("CollisionShape3D")

	if id_input < 0 or id_input >= prefabs_list_lengkap.size():
		if preview_object != null:
			preview_object.mesh = null
			preview_object.material_override = null
		if spawner_collision != null:
			spawner_collision.shape = null
		return

	if spawner_collision == null:
		return

	var temp_instance = prefabs_list_lengkap[id_input].instantiate()
	var target_shape: Shape3D = null

	for child in temp_instance.get_children():
		if child is CollisionShape3D and child.shape != null:
			target_shape = child.shape
			break

	if target_shape != null:
		# 1. Update Collision Shape
		spawner_collision.shape = target_shape.duplicate()
		
		# 2. Update Mesh milik Preview Object sesuai jenis Shape
		if preview_object != null:
			_apply_shape_to_preview_mesh(target_shape)
			_check_preview_placement_validity()

	temp_instance.free()

func _apply_shape_to_preview_mesh(shape: Shape3D) -> void:
	if shape is BoxShape3D:
		var box_mesh = BoxMesh.new()
		box_mesh.size = shape.size
		preview_object.mesh = box_mesh
	elif shape is CylinderShape3D:
		var cyl_mesh = CylinderMesh.new()
		cyl_mesh.top_radius = shape.radius
		cyl_mesh.bottom_radius = shape.radius
		cyl_mesh.height = shape.height
		preview_object.mesh = cyl_mesh
	elif shape is SphereShape3D:
		var sphere_mesh = SphereMesh.new()
		sphere_mesh.radius = shape.radius
		sphere_mesh.height = shape.radius * 2.0
		preview_object.mesh = sphere_mesh


func _on_colliding_checkers_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if can_place and not _is_spawning:
			if tutorial != null:
				tutorial.visible = true
				
			if not Global.currently_are_selecting:
				return
				
			if not Global.currently_are_delete:
				if overlapping_area_3d.get_overlapping_areas().is_empty():
					if id_input >= 0 and type_building_input != null:
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
	if _is_spawning:
		return
	_is_spawning = true
	
	if id < 0 or id >= prefabs_list_lengkap.size():
		push_error("ID Prefab tidak valid: " + str(id))
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
