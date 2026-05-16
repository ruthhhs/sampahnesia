extends RayCast3D

var height_curve: float = 2.0
var dragging_access: bool = false
@export var target_send: Area3D = null
@export var enable_mesh:MeshInstance3D
@export var disable_mesh:MeshInstance3D
@export var interact_line: Area3D
@onready var sprite_3d = $DistributePath/Ekspedisi/Package/Sprite3D
var _texture_sprite: Texture2D
@export var texture_sprite: Texture2D:
	set(value):
		print("texture sprite", value)
		_texture_sprite = value
		
		if is_instance_valid(sprite_3d):
			sprite_3d.texture = value

var overlap_line: int = 0
var overlap_bangunan: int = 0
var value_recive: int = 1
var speed_expedition: int = 25
var price: int
var my_parent 
var the_parent: Area3D
var can_sell: bool = false
var pause_progress: bool = false
var can_connect: bool = true:
	set(value):
		if enable_mesh != null and disable_mesh != null:
			if value == true:
				print("can connect: ", value)
				enable_mesh.visible = true
				disable_mesh. visible = false
			else:
				print("can connect: ", value)
				enable_mesh. visible = false
				disable_mesh. visible = true
	get:
		return can_connect
@onready var area_selected:Area3D = $AreaSelected
@onready var scaler:Node3D = $Scaller
@onready var distribute_path:Path3D = $DistributePath

func _ready() -> void:
	#print(texture_sprite)
	#%Sprite3D.texture = texture_sprite
	the_parent = get_parent().get_parent()
	distribute_path.curve = Curve3D.new()
	distribute_path.curve.add_point(Vector3.ZERO)
	distribute_path.curve.add_point(Vector3(0.04, 0, 0))

func _input(event: InputEvent) -> void:
	if dragging_access:
		#look_at(Global.mouse_pos)
		var get_position: Vector3
		if target_send != null:
			get_position = target_send.global_position
		else:
			get_position = Global.mouse_pos
		var dir = (get_position - global_position)
		var angle = atan2(dir.x, dir.z) # z dan x dibalik karena Godot 3D pakai z sebagai depan
		rotation.y = angle
		target_position.z = global_position.distance_to(get_position)/2
		scaler.scale.y = -target_position.z
		area_selected.global_position.x = get_position.x
		area_selected.global_position.z = get_position.z
		distribute_path.curve.set_point_position(1, Vector3(-target_position.z,0,0))
		distribute_path.curve.set_point_out(0,Vector3(-target_position.z/2,height_curve+(target_position.z/3),0))

		if Input.is_action_just_released("mouse_selected") and target_send == null:
			#tidak terpakai
			dragging_access = false
			rotation.y = 0
			target_position.z = 0
			area_selected.global_position.x = global_position.x
			area_selected.global_position.z = global_position.z
			scaler.scale.y = 0.065
			distribute_path.curve.set_point_position(1, Vector3(0.04, 0, 0))
			queue_free()

func _process(delta: float) -> void:
	if target_send != null:
		if the_parent.is_electric_usage == true:
				
			if the_parent.item_value > 0 and the_parent.electric_item >0:
				%Ekspedisi.progress += speed_expedition * delta
			else:
				%Ekspedisi.progress_ratio = 0
		else:
			if the_parent.item_value > 0:
				%Ekspedisi.progress += speed_expedition * delta
			else:
				%Ekspedisi.progress_ratio = 0

# melakukan interaksi koneksi
func _on_area_selected_area_entered(area: Area3D) -> void:

	if "parent_group" in area :
		#print(area)
		for i in get_parent().get_parent().target_group: # mengecek apakah masuk target
			if area.parent_group == i: #jika iya makan akan ngecek nama si ara
				#print("node yang terkoneksi = ",area)
				if not area.list_node_tersambung.has(my_parent) and %Disable.visible == false:
					area.list_node_tersambung.append(my_parent)
					my_parent.list_node_tersambung.append(area)
					target_send = area
					print("connected?")
					#can_connect = true
					#status jadi toko
					if area.is_get_money == true:
						for j in range(area.that_can_sell.size()) :
							#print("index yang bisa dijual: ",area.that_can_sell[j], " | sedangkan yang terkoneksi: ",get_parent().get_parent().parent_group)
							#print("yang bisa dijual adalah: ",area.that_can_sell[0])
							if get_parent().get_parent().parent_group == area.that_can_sell[j]:
								price = area.price_amount_target_group[j]

func _delete_connection()-> void:
	if my_parent != null:
		target_send.list_node_tersambung.erase(my_parent)
		my_parent.list_node_tersambung.erase(target_send)
		queue_free()
	else:
		print("kondisi parent: ", my_parent)
func _on_interact_to_line_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed: 
		print("kedapetan")
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
			print("keluar ke area raycaster")
		if area.is_in_group("Objek") and not area == get_parent().get_parent():
			overlap_bangunan -= 1
		if overlap_bangunan == 0 and overlap_line == 0:
			can_connect = true

func _on_package_area_entered(area: Area3D) -> void:
	if area == target_send:
		if "item_value" in area:
			var bangunan_parent:= get_parent().get_parent()
			if area != get_parent().get_parent(): #bukan diri sendiri
				if bangunan_parent.is_electric_production == false:
					area.item_value += value_recive
					bangunan_parent.item_value = bangunan_parent.item_value - value_recive
					Global.stat_money += price
					if bangunan_parent.is_electric_usage == true:
						bangunan_parent.electric_item = bangunan_parent.electric_item - value_recive
				else:
					area.electric_item += value_recive
					
					bangunan_parent.electric_item = bangunan_parent.electric_item - value_recive
