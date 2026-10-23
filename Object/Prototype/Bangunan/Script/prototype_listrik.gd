class_name Building
extends Area3D

var destroy_timer_access: Node3D
var infinity_symbol: String = "∞"
var list_node_tersambung: Array[Area3D]
var simpan_harga_bangunan: int
var standard_speed: int = 25
var new_speed: int
var shorcut_electric_usage: bool
var maximum_electric_item: int

var on_maintenance: bool = false:
	set(value):
		if on_maintenance == value:
			return
		on_maintenance = value
		if on_maintenance:
			sprite_3d.visible = false
		else:
			# timer sudah selesai / hilang, buang referensinya
			destroy_timer_access = null
			sprite_3d.visible = Global.currently_are_inspecting

@export_group("Type")
@export var is_sampah: bool = false
@export_group("Popup")
@export var popup_hover: Control
#@export var popup_warning: Control
@export var image_input_value_item: TextureRect
@export var electrical_box_container: HBoxContainer
@export var label_value_item: Label
@export var label_electricity_item: Label
@export var popup_warning_value: TextureRect
@export var popup_warning_electricity: TextureRect
@export var state_building: Node3D
@export var output_texture: CompressedTexture2D
@export var input_texture: CompressedTexture2D
@export_group("Linked")
@export var parent_group: String
@export var target_group: Array[String]
@export var maximum_item_value: int = 10
@export var slow_down_speed_expedition: int = 0 #current progress
@export_group("Effect")
@export var particle_trigger: GPUParticles3D
@export_group("Polluted")
@export var jumlah_polusi: int
@export var auto_get_polute: bool = false
@export_group("production")
@export var item_value: int:
	set(value):
		if particle_trigger != null:
			particle_trigger.emitting = true
		if not is_get_money:
			item_value = clamp(value, 0, maximum_item_value)

		if popup_warning_value != null:
			popup_warning_value.visible = (item_value <= 0)

		update_warning_visibility()

		if is_self_added:
			item_value += 1

		if label_value_item != null and not is_self_added:
			label_value_item.text = str(item_value, "/", maximum_item_value, " ")

		#if is_get_money == true:
			#pass

		if state_building != null:
			var range_1: float = lerp(0, maximum_item_value, 0.7)
			var range_2: float = lerp(0, maximum_item_value, 0.3)

			if item_value >= range_1:
				state_building.full()
			elif item_value < range_1 and item_value >= range_2:
				state_building.medium()
			elif item_value < range_2 and item_value > 0:
				state_building.small()
			elif item_value <= 0:
				state_building.empty()
	get:
		return item_value
@export var is_self_added: bool = false
@export var infinite_connection: bool = false
@export var kapasitas_koneksi: int = 2
@export var is_get_money: bool = false
@export var can_sell: bool = false
@export var maintenance_activity_id: int = 2
@export var price: int = 0
@export_group("Electrical")
@export var is_electric_production: bool = false
@export var is_electric_usage: bool = false:
	set(value):
		shorcut_electric_usage = value
		if value == true:
			if popup_warning_electricity != null and electrical_box_container != null:
				popup_warning_electricity.visible = true
				electrical_box_container.visible = true
		else:
			if popup_warning_electricity != null and electrical_box_container != null:
				popup_warning_electricity.visible = false
				electrical_box_container.visible = false
	get():
		return is_electric_usage
@export var electric_item: int:
	set(value):
		electric_item = clamp(value, 0, maximum_electric_item)

		if label_electricity_item != null and not is_self_added:
			label_electricity_item.text = str(electric_item, "/", maximum_electric_item, " ")

		if popup_warning_electricity != null:
			if is_electric_usage:
				popup_warning_electricity.visible = (electric_item <= 0)
			else:
				popup_warning_electricity.visible = false

		update_warning_visibility()
	get:
		return electric_item
@export_group("Delete")
@export var can_delete: bool = true

@onready var raycaster = preload("res://Object/Prototype/Bangunan/raycaster.tscn")
@onready var waiting_for_delete = preload("res://Assets/Shaders/WaitingForDelete.tres")
@onready var destroy_particle = preload("res://Object/Prefabs/DestroyParticle/destroy_particle.tscn")
@onready var destroy_timer = preload("res://Object/Prefabs/DestroyTimer/destroy_timer.tscn")
@onready var maintenance_popup = preload("res://UI/Scnee/PopupBuyRepair/popup_buy_repair.tscn")
@onready var kumpulan_ray: Node3D = $KumpulanRay
@onready var debug_label: Label = $Sprite3D/SubViewport/DebugLabel
@onready var sprite_3d: Sprite3D = $Sprite3D


# ==========================================
# Sentralisasi Logika Warning
# ==========================================
func update_warning_visibility() -> void:
	if is_electric_production:
		is_electric_usage = false
	#if popup_warning == null:
		#return

	var needs_warning: bool = false

	if popup_warning_value != null and popup_warning_value.visible:
		needs_warning = true

	if popup_warning_electricity != null and popup_warning_electricity.visible:
		needs_warning = true

	if popup_hover != null and popup_hover.visible:
		pass
		#popup_warning.visible = false
	else:
		pass
		#popup_warning.visible = needs_warning
# ==========================================

func _see_on_inspect(is_inspecting: bool) -> void:
	sprite_3d.visible = is_inspecting

func _ready() -> void:
	Global.is_inspecting.connect(_see_on_inspect)
	_see_on_inspect(Global.currently_are_inspecting)
	if not is_self_added:
		update_warning_visibility()
	new_speed = standard_speed
	kumpulan_ray.child_order_changed.connect(_on_jumlah_child_berubah)
	Global.delete_change.connect(_on_delete_change)
	maximum_electric_item = maximum_item_value
	if popup_warning_value != null and input_texture != null:
		popup_warning_value.texture = input_texture

	if image_input_value_item != null:
		image_input_value_item.texture = input_texture

	if is_self_added == true:
		item_value = 1

	if label_value_item != null:
		label_value_item.text = str(item_value, "/", maximum_item_value, " ")
	if label_electricity_item != null:
		label_electricity_item.text = str(electric_item, "/", maximum_electric_item, " ")
	if is_electric_production == true:
		if is_self_added == true:
			label_value_item.text = infinity_symbol
			image_input_value_item.visible = false
			image_input_value_item.get_parent().get_child(1).visible = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_end"):
		item_value = item_value + 1

func add_raycast() -> void:
	if kumpulan_ray.get_child_count() < kapasitas_koneksi or infinite_connection == true:
		var raycaster_instanciate = raycaster.instantiate()
		kumpulan_ray.add_child(raycaster_instanciate)
		raycaster_instanciate.texture_sprite = output_texture
		raycaster_instanciate.global_position = kumpulan_ray.global_position
		raycaster_instanciate.dragging_access = true
		raycaster_instanciate.my_parent = self

func _reset_drag_multiple(node: Area3D) -> void:
	for child in kumpulan_ray.get_children():
		if child is RayCast3D and child.target_send == node:
			child._delete_connection()

func delete_my_self() -> void:
	# particle
	var destroy_particle_instance = destroy_particle.instantiate()
	destroy_particle_instance.position = global_position
	get_parent().get_parent().add_child(destroy_particle_instance)

	# refund setengah
	if simpan_harga_bangunan > 1 and on_maintenance == false:
		Global.stat_money += roundi(simpan_harga_bangunan / 2.0)

	# hapus koneksi sendiri
	for child in kumpulan_ray.get_children():
		if child is RayCast3D and child.has_method("_delete_connection"):
			child._delete_connection()

	var copy_from_list_node = list_node_tersambung.duplicate()
	for node in copy_from_list_node:
		if node.has_method("_reset_drag_multiple"):
			node._reset_drag_multiple(self)

	queue_free()

func change_input_output_texture():
	if image_input_value_item != null and popup_warning_value != null:
		image_input_value_item.texture = input_texture
		popup_warning_value.texture = input_texture

# ==========================================
# Spawn minigame repair
# ==========================================
func _open_maintenance_popup() -> void:
	if not is_instance_valid(destroy_timer_access):
		return
	if destroy_timer_access.is_repair:
		return

	var root := get_parent().get_parent()
	var container: CanvasLayer = root.get_child(root.get_child_count() - 1)

	# bersihkan popup lama
	for child in container.get_children():
		child.queue_free()

	var popup := maintenance_popup.instantiate()
	# set SEBELUM add_child supaya sudah terisi saat _ready popup jalan
	popup.destroy_timer_node_insert = destroy_timer_access
	if is_get_money == true:
		popup.id_minigame = 3
	elif is_electric_production == true:
		popup.id_minigame = 1
	else:
		popup.id_minigame = maintenance_activity_id
	popup.id_minigame = maintenance_activity_id
	
	container.add_child(popup)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if Global.currently_are_inspecting:
			if on_maintenance:
				_open_maintenance_popup()
			elif event.button_index == MOUSE_BUTTON_LEFT and target_group.size() != 0:
				if kumpulan_ray.get_child_count() == 0:
					add_raycast()
				else:
					var last_ray = kumpulan_ray.get_child(kumpulan_ray.get_child_count() - 1)
					if last_ray.target_send != null:
						add_raycast()
					else:
						last_ray.dragging_access = true
		elif Global.currently_are_delete and can_delete:
			delete_my_self()

func _on_mouse_entered() -> void:
	if can_delete == true and Global.currently_are_delete:
		get_child(0).get_child(0).material_overlay = waiting_for_delete

func _on_mouse_exited() -> void:
	if can_delete == true:
		get_child(0).get_child(0).material_overlay = null

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("water") and on_maintenance == false:
		if is_sampah == false:
			var destroy_timer_instance = destroy_timer.instantiate()
			destroy_timer_access = destroy_timer_instance
			add_child(destroy_timer_instance)
			on_maintenance = true
	if area.is_in_group("collision_checkers") and Global.currently_are_inspecting:
		if popup_hover != null:
			popup_hover.visible = true
		update_warning_visibility()

func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("collision_checkers") and Global.currently_are_inspecting:
		if popup_hover != null:
			popup_hover.visible = false
		update_warning_visibility()

func _on_delete_change(is_can_delete: bool) -> void:
	if is_can_delete:
		sprite_3d.visible = false
	else:
		sprite_3d.visible = true
func _on_jumlah_child_berubah() -> void:
	if infinite_connection:
		return

	var total_child: int = kumpulan_ray.get_child_count()
	if total_child == 0:
		return

	if kapasitas_koneksi <= 1:
		# hanya 1 koneksi, tidak ada yang perlu diperlambat
		new_speed = standard_speed
	elif total_child >= kapasitas_koneksi:
		# koneksi penuh, berhenti
		new_speed = 0
	else:
		new_speed = roundi(remap(total_child, 1, kapasitas_koneksi, standard_speed, 0.0))
		# nilai 1 di raycast berarti berhenti, jadi koneksi yang belum penuh minimal 2
		new_speed = maxi(new_speed, 2)

	print("koneksi: ", total_child, "/", kapasitas_koneksi, " | new_speed: ", new_speed)

	for ray in kumpulan_ray.get_children():
		ray.speed_expedition = new_speed
		print("kecepatan ", ray, " = ", ray.speed_expedition)
