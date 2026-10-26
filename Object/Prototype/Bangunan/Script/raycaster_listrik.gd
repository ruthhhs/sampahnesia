extends RayCast3D

var height_curve: float = 2.0
var dragging_access: bool = false
var is_delivering: bool = false # Tambahan variabel state baru

@onready var electricity_material: StandardMaterial3D = preload("res://Assets/Shaders/electricity.tres")
@export var target_send: Area3D = null:
	set(value):
		if target_send != value:
			target_send = value
			if get_parent().get_parent().building_category == 1:
				Global.first_sampah_input = true
			elif  get_parent().get_parent().building_category == 2:
				Global.first_pertanian_input = true
			elif get_parent().get_parent().building_category == 3:
				Global.first_perternakan_input = true
			elif  get_parent().get_parent().building_category == 4:
				Global.first_toko_input = true
			#match get_parent().get_parent().building_category:
				#"SAMPAH":
					#print("sampah")
					##Global.first_sampah_input = true
				#"PERTANIAN":
					#print("pertanian")
					##Global.first_pertanian_input = true
				#"PETERNAKAN":
					#print("perternakan")
					##Global.first_perternakan_input = true
				#"TOKO":
					#print("toko")
					##Global.first_toko_input = true
@export var enable_mesh: MeshInstance3D
@export var disable_mesh: MeshInstance3D
@export var interact_line: Area3D

@onready var sprite_3d = $DistributePath/Ekspedisi/Package/Sprite3D

var _texture_sprite: Texture2D
@export var texture_sprite: Texture2D:
	set(value):
		_texture_sprite = value
		if is_instance_valid(sprite_3d):
			sprite_3d.texture = value

var overlap_line: int = 0
var overlap_bangunan: int = 0
var value_recive: int = 1
var speed_applier: int = 25
var speed_expedition: int = 25:
	set(value):
		# nilai minimal selalu 1 (1 = berhenti)
		speed_expedition = max(1, value)
		speed_applier = speed_expedition
var price: int
var my_parent 
var the_parent: Area3D
var can_sell: bool = false
var pause_progress: bool = false

var can_connect: bool = true:
	set(value):
		can_connect = value
		if enable_mesh != null and disable_mesh != null:
			if value == true:
				enable_mesh.visible = true
				disable_mesh.visible = false
			else:
				enable_mesh.visible = false
				disable_mesh.visible = true
	get:
		return can_connect

@onready var area_selected: Area3D = $AreaSelected
@onready var scaler: Node3D = $Scaller
@onready var distribute_path: Path3D = $DistributePath

func _ready() -> void:
	the_parent = get_parent().get_parent()
	speed_expedition = the_parent.new_speed
	speed_applier = speed_expedition
	distribute_path.curve = Curve3D.new()
	distribute_path.curve.add_point(Vector3.ZERO)
	distribute_path.curve.add_point(Vector3(0.04, 0, 0))
	if the_parent.is_electric_production == true:
		%Enable.material_override = electricity_material

func _input(_event: InputEvent) -> void:
	if dragging_access:
		var get_positions: Vector3
		if target_send != null:
			get_positions = target_send.global_position
		else:
			get_positions = Global.mouse_pos
			
		var dir = (get_positions - global_position)
		var angle = atan2(dir.x, dir.z) # z dan x dibalik karena Godot 3D pakai z sebagai depan
		rotation.y = angle
		
		target_position.z = global_position.distance_to(get_positions) / 2
		scaler.scale.y = -target_position.z
		
		area_selected.global_position.x = get_positions.x
		area_selected.global_position.z = get_positions.z
		
		distribute_path.curve.set_point_position(1, Vector3(-target_position.z, 0, 0))
		distribute_path.curve.set_point_out(0, Vector3(-target_position.z / 2, height_curve + (target_position.z / 3), 0))

		if Input.is_action_just_released("mouse_selected"):
			dragging_access = false # Mutlak dimatikan agar tidak bocor target
			
			if target_send == null:
				# Dibatalkan / tidak terhubung ke bangunan
				rotation.y = 0
				target_position.z = 0
				area_selected.global_position.x = global_position.x
				area_selected.global_position.z = global_position.z
				scaler.scale.y = 0.065
				distribute_path.curve.set_point_position(1, Vector3(0.04, 0, 0))
				queue_free()

func _process(delta: float) -> void:
	if target_send == null:
		return
		
	var is_target_full: bool = false
	
	# 1. Cek apakah kapasitas target penuh
	if the_parent.is_electric_production:
		is_target_full = (target_send.electric_item >= target_send.maximum_electric_item)
	else:
		is_target_full = (target_send.item_value >= target_send.maximum_item_value)

	# 2. Jika paket sedang stanby (belum berangkat)
	if not is_delivering:
		var can_start_delivery: bool = false
		
		# Cek ketersediaan resource di pengirim
		if the_parent.is_electric_production:
			can_start_delivery = (the_parent.is_self_added or the_parent.item_value > 0)
		else:
			if the_parent.is_electric_usage:
				can_start_delivery = (the_parent.item_value > 0 and the_parent.electric_item > 0)
			else:
				can_start_delivery = (the_parent.item_value > 0)
		
		# BERANGKAT! Kurangi resource di awal keberangkatan
		if can_start_delivery and not is_target_full:
			is_delivering = true
			
			if the_parent.is_electric_production == false:
				the_parent.item_value -= value_recive
				if the_parent.shorcut_electric_usage == true:
					the_parent.electric_item -= value_recive
			else:
				if the_parent.is_self_added == false:
					the_parent.item_value = max(0, the_parent.item_value - value_recive)
				the_parent.electric_item = max(0, the_parent.electric_item - value_recive)

	# 3. Eksekusi pergerakan di jalan
	if is_delivering:
		sprite_3d.visible = true
		#if speed_applier > 1:
			
		%Ekspedisi.progress += speed_applier * delta
	else:
		# Menunggu resource atau target full
		sprite_3d.visible = false
		%Ekspedisi.progress = 0

func _delete_connection() -> void:
	if my_parent != null:
		if target_send != null:
			target_send.list_node_tersambung.erase(my_parent)
		my_parent.list_node_tersambung.erase(target_send)
		queue_free()

# Melakukan interaksi koneksi (menyambungkan bangunan)
func _on_area_selected_area_entered(area: Area3D) -> void:
	# Mencegah target terganti kalau area tidak sengaja menyentuh bangunan baru
	if target_send != null:
		return 
		
	if the_parent.is_electric_production == true:
		if "is_electric_usage" in area and "is_electric_production" in area:
			var usage: bool = area.shorcut_electric_usage 
			var produc: bool = area.is_electric_production
			if usage == true and produc == false:
				print("bisa menyambung")
				area.list_node_tersambung.append(my_parent)
				my_parent.list_node_tersambung.append(area)
				target_send = area
			print("usage status: ", area.shorcut_electric_usage, " | ","is_electric_production: ", area.is_electric_production)
	else:
		if "parent_group" in area:
			for i in the_parent.target_group: # mengecek apakah masuk target
				if area.parent_group == i: 
					if not area.list_node_tersambung.has(my_parent) and %Disable.visible == false and area != the_parent:
						area.list_node_tersambung.append(my_parent)
						my_parent.list_node_tersambung.append(area)
						target_send = area

# Interact to line (Delete Koneksi via klik)
func _on_interact_to_line_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed: 
		if Global.currently_are_delete == true:
			_delete_connection()

func _on_interact_to_line_area_entered(area: Area3D) -> void:
	if target_send == null and interact_line != null:
		if area.is_in_group("raycaster") and not area.get_parent().get_parent().get_parent() == get_parent() and area.get_parent().get_parent().target_send != the_parent:
			can_connect = false
			overlap_line += 1
		if area.is_in_group("Objek") and not area == get_parent().get_parent():
			can_connect = false
			overlap_bangunan += 1

func _on_interact_to_line_area_exited(area: Area3D) -> void:
	if target_send == null and interact_line != null:
		if area.is_in_group("raycaster") and not area.get_parent().get_parent().get_parent() == get_parent() and area.get_parent().get_parent().target_send != the_parent:
			overlap_line -= 1
		if area.is_in_group("Objek") and not area == get_parent().get_parent():
			overlap_bangunan -= 1
			
		if overlap_bangunan == 0 and overlap_line == 0:
			can_connect = true

# Fungsi Utama Pengiriman Paket (Sampai di Tujuan)
func _on_package_area_entered(area: Area3D) -> void:
	# Hanya proses jika area adalah target dan statusnya sedang mengirim
	if area == target_send and is_delivering:
		if area != get_parent().get_parent(): # bukan mengirim ke diri sendiri
			%AudioEnd.play()
			
			if the_parent.is_electric_production == false:
				# --- PROSES TRANSFER BARANG (NON-LISTRIK) ---
				area.item_value += value_recive
				
				if area.is_get_money == true and the_parent.can_sell == true:
					Global.stat_money += the_parent.price
					Global.first_toko_input = true
					
			else:
				# --- PROSES TRANSFER LISTRIK ---
				area.electric_item += value_recive
				
		# PENTING: Matikan state pengiriman dan reset posisi ke titik awal
		is_delivering = false
		speed_applier = speed_expedition
		%Ekspedisi.progress = 0

func _on_interact_to_line_mouse_entered() -> void:
	if Global.currently_are_delete == true:
		%Disable.visible = true
		%Enable.visible = false

func _on_interact_to_line_mouse_exited() -> void:
	if Global.currently_are_delete == true:
		%Disable.visible = false
		%Enable.visible = true
