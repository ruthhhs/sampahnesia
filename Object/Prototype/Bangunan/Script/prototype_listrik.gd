class_name Building
extends Area3D
var list_node_tersambung: Array[Area3D]
@export var output_texture: CompressedTexture2D
@export var input_texture: Texture2D
@export var parent_group: String
@export var target_group: Array[String]
@export var maximum_item_value: int = 5
@export var item_value: int:
	set(value):
		item_value = clamp(value,0,maximum_item_value)
		if is_self_added:
			item_value += 1
			
		if is_get_money == true:
			pass #menambahkan kondisi misal memberi animasi
	get:
		return item_value
@export var auto_get_polute: bool = false
@export var jumlah_polusi: int
@export var is_self_added: bool = false
@export var infinite_connection: bool = false
@export var kapasitas_koneksi: int = 2
@export var is_get_money: bool = false
@export var price_amount_target_group:Array[int]
@export var that_can_sell: Array[String]
@export var icon_target_group: Array[CompressedTexture2D]
@export var is_electric_production: bool = false
@export var is_electric_usage: bool = false
@export var maximum_electric_item: int = 3
@export var electric_item: int:
	set(value):
		electric_item = clamp(value,0,maximum_electric_item)
	get:
		return electric_item
@export var can_delete: bool = true
@onready var raycaster = preload("res://Object/Prototype/Bangunan/raycaster.tscn")
@onready var kumpulan_ray :Node3D = $KumpulanRay
@onready var debug_label: Label = $Sprite3D/SubViewport/DebugLabel

func _ready() -> void:
	
	if is_self_added == true:
		item_value = 1

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_end"):
		item_value = item_value + 1
func _process(delta: float) -> void:
	debug_label.text = str("\nelectric left: ", electric_item,"\ninventory left: ", item_value )
func add_raycast()->void:
	if kumpulan_ray.get_child_count() < kapasitas_koneksi or infinite_connection == true :
		var raycaster_instanciate = raycaster.instantiate() 
		kumpulan_ray.add_child(raycaster_instanciate)
		raycaster_instanciate.texture_sprite = output_texture
		print(raycaster_instanciate.texture_sprite)
		raycaster_instanciate.global_position = kumpulan_ray.global_position 
		raycaster_instanciate.dragging_access = true
		raycaster_instanciate.my_parent = self

func _reset_drag_multiple(node: Area3D)->void:
	for child in kumpulan_ray.get_children():
		if child is RayCast3D and child.target_send == node:
			child._delete_connection()

func delete_my_self()-> void:
	#deleting own connection
	for child in kumpulan_ray.get_children():
		if child is RayCast3D and child.has_method("_delete_connection"):
			child._delete_connection()
	var copy_from_list_node = list_node_tersambung.duplicate()
	for node in copy_from_list_node:
		if node.has_method("_reset_drag_multiple"):
			node._reset_drag_multiple(self)
	queue_free()

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if Global.currently_are_delete == false :
			if event.button_index == MOUSE_BUTTON_LEFT and target_group.size() != 0:
				if kumpulan_ray.get_child_count() == 0:
					add_raycast()
				else:
					if kumpulan_ray.get_child(kumpulan_ray.get_child_count() - 1).target_send != null:
						add_raycast()
					else:
						kumpulan_ray.get_child(kumpulan_ray.get_child_count() - 1).dragging_access = true
		else:
			if can_delete == false:
				
				delete_my_self()

func _on_mouse_entered() -> void:
	#print("masuk")
	pass

func _on_mouse_exited() -> void:
	#print("keluar")
	pass
