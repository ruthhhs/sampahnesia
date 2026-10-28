extends Node

var name_city: String = "sampahnesia"
var mouse_pos: Vector3
var ending_id: int = 0
var on_tutorial: bool = true
var on_pause: bool = false
# Signal untuk memberitahu sistem lain jika state tutorial berubah
signal tutorial_state_changed(is_active: bool)

# Referensi ke instance node tutorial yang sedang berjalan
var active_tutorial_instance: Node = null

var is_on_tutorial: bool = false:
	set(value):
		if is_on_tutorial != value:
			is_on_tutorial = value
			tutorial_state_changed.emit(is_on_tutorial)

signal is_inspecting(new_value: bool)
var currently_are_inspecting: bool:
	set(value):
		if currently_are_inspecting != value:
			currently_are_inspecting = value
			is_inspecting.emit(currently_are_inspecting)

signal is_selecting(new_value: bool)
var currently_are_selecting: bool:
	set(value):
		if currently_are_selecting != value:
			currently_are_selecting = value
			print(currently_are_selecting)
			is_selecting.emit(currently_are_selecting)

signal delete_change(new_value: bool)
var currently_are_delete: bool:
	set(value):
		if currently_are_delete != value:
			currently_are_delete = value
			delete_change.emit(currently_are_delete)

signal is_raining(new_value: bool)
var currently_are_raining: bool = false:
	set(value):
		if currently_are_raining != value:
			currently_are_raining = value
			is_raining.emit(currently_are_raining)

signal money_change(new_value: int)
var stat_money: int = 0:
	set(value):
		if stat_money != value:
			stat_money = value
			money_change.emit(stat_money)
			if stat_money >= 10000:
				Archivement.validate_archivement(3)
			if stat_money >= 20000:
				Archivement.validate_archivement(4)

var stat_polution: int = 1
var stat_oxigen: int = 1
var repairement_unused: int = 3

# Flag Koneksi Pertama Per Tipe Bangunan
signal first_sampah_signal(new_value: bool)
signal first_pertanian_signal(new_value: bool)
signal first_perternakan_signal(new_value: bool)
signal first_toko_signal(new_value: bool)
signal first_nebang_signal(new_value: bool)
signal first_nanem_signal(new_value: bool)
signal first_sampah_double_linked_signal(new_value: bool)
signal first_bangunan_double_linked_signal(new_value: bool)
signal first_bangunan_double_input_signal(new_value: bool)
signal first_destroy_raycast_signal(new_value: bool)
signal first_building_damage_signal(new_value: bool)
var first_sampah_input: bool = false:
	set(value):
		if first_sampah_input != value:
			first_sampah_input = value
			first_sampah_signal.emit(first_sampah_input)
var first_pertanian_input: bool = false:
	set(value):
		if first_pertanian_input != value and first_sampah_input == true:
			first_pertanian_input = value
			first_pertanian_signal.emit(first_pertanian_input)
var first_perternakan_input: bool = false:
	set(value):
		if first_perternakan_input != value and first_pertanian_input == true:
			first_perternakan_input = value
			first_perternakan_signal.emit(first_perternakan_input)
var first_toko_input: bool = false:
	set(value):
		if first_toko_input != value and first_perternakan_input == true:
			
			first_toko_input = value
			first_toko_signal.emit(first_toko_input)
var first_nebang_pohon: bool = false :
	set(value):
		if first_nebang_pohon != value and first_toko_input:
			first_nebang_pohon = value
			first_nebang_signal.emit(first_nebang_pohon)
var first_nanem_pohon: bool = false :
	set(value):
		if first_nanem_pohon != value and first_nebang_pohon:
			first_nanem_pohon = value
			first_nanem_signal.emit(first_nanem_pohon)

var first_sampah_double_linked: bool = false:
	set(value):
		if first_sampah_double_linked != value and first_nanem_pohon:
			first_sampah_double_linked = value
			first_sampah_double_linked_signal.emit(first_sampah_double_linked)
var first_bangunan_double_linked: bool = false: #not yet implement
	set(value):
		if first_bangunan_double_linked != value and first_sampah_double_linked:
			first_bangunan_double_linked = value
			first_bangunan_double_linked_signal.emit(first_bangunan_double_linked)
			
var first_bangunan_double_input: bool = false: #not yet implement
	set(value):
		if first_bangunan_double_input != value and first_bangunan_double_linked:
			first_bangunan_double_input = value
			first_bangunan_double_input_signal.emit(first_bangunan_double_input)

var first_destroy_raycster: bool = false: #not yet implement
	set(value):
		if first_destroy_raycster != value and first_bangunan_double_input:
			first_destroy_raycster = value
			first_destroy_raycast_signal.emit(first_destroy_raycster)
var first_building_damage: bool = false:
	set (value):
		if first_building_damage != value and first_destroy_raycster:
			first_building_damage = value
			first_building_damage_signal.emit(first_building_damage)


# --- FUNGSI MANAJEMEN TUTORIAL ---
func register_tutorial(tutorial_node: Node) -> void:
	if is_instance_valid(active_tutorial_instance) and active_tutorial_instance != tutorial_node:
		if active_tutorial_instance.has_method("_force_delete"):
			active_tutorial_instance._force_delete()
		else:
			active_tutorial_instance.queue_free()
	
	active_tutorial_instance = tutorial_node
	is_on_tutorial = true


func unregister_tutorial(tutorial_node: Node) -> void:
	if active_tutorial_instance == tutorial_node:
		active_tutorial_instance = null
		is_on_tutorial = false


# --- FUNGSI RESET GLOBAL ---
func reset_game_data() -> void:
	name_city = "sampahnesia"
	mouse_pos = Vector3.ZERO
	
	if is_instance_valid(active_tutorial_instance):
		active_tutorial_instance.queue_free()
	ending_id = 0
	active_tutorial_instance = null
	is_on_tutorial = true
	
	currently_are_inspecting = false
	currently_are_selecting = false
	currently_are_delete = false
	currently_are_raining = false
	
	stat_money = 0
	stat_polution = 1
	stat_oxigen = 1
	repairement_unused = 3
	
	# Reset status koneksi tutorial
	first_sampah_input = false
	first_pertanian_input = false
	first_perternakan_input = false
	first_toko_input = false
	first_nebang_pohon = false
	first_nanem_pohon = false
	first_sampah_double_linked = false
	first_bangunan_double_linked = false
	first_bangunan_double_input = false
	first_destroy_raycster = false
	first_building_damage = false
	if Archivement.has_method("reset_archivement"):
		Archivement.reset_archivement()
