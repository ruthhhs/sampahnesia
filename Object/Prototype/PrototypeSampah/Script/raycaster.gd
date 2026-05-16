extends RayCast3D


var height_curve: float = 2.0
var dragging_access: bool = false
@export var target_send: Area3D = null
var my_parent 
@onready var area_selected:Area3D = $AreaSelected
@onready var scaler:Node3D = $Scaller
@onready var distribute_path:Path3D = $DistributePath

func _ready() -> void:
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
			dragging_access = false
			rotation.y = 0
			target_position.z = 0
			area_selected.global_position.x = global_position.x
			area_selected.global_position.z = global_position.z
			scaler.scale.y = 0.065
			
			distribute_path.curve.set_point_position(1, Vector3(0.04, 0, 0))

func _on_area_selected_area_entered(area: Area3D) -> void:
	if area.is_in_group("bangunan")or area.is_in_group("listrik_kotor"):
		if area != null:
				
			if not area.global_position == my_parent.global_position and not area.list_node_tersambung.has(my_parent):
				area.list_node_tersambung.append(my_parent)
				target_send = area

func _reset_drag()-> void:
	pass

func _on_interact_to_line_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and Global.currently_are_delete == true:
		target_send.list_node_tersambung.erase(my_parent)
		queue_free()
