class_name Bangunan
extends Area3D

var dragging_access : bool = false
var list_node_tersambung: Array[Area3D]
@onready var drag_to: RayCast3D = $RayCast3D
@onready var scaler: Node3D = $RayCast3D/Scaller
@onready var area_selected: Area3D = $AreaSelected
@onready var distribute_path: Path3D = $RayCast3D/DistributePath

@export var myself: Area3D
@export var parent_group: String

var visited: int 
var pinned_position: Vector3 = Vector3.ZERO
var to: Vector3 
var height_curve: float = 2.0
var target_send: Area3D

#dragging
var direction: Vector3
var target_pos:Vector3
var look_rotation:Vector3
var distance: float
var distance_square:float

func _ready() -> void:
	drag_to.visible = false
	area_selected.position = Vector3.ZERO
	distribute_path.curve = Curve3D.new()
	distribute_path.curve.add_point(Vector3.ZERO)
	distribute_path.curve.add_point(Vector3(0.04, 0, 0))	

func _input(_event: InputEvent) -> void:
	if Global.currently_are_selecting and not dragging_access:
		$AreaSelected/CollisionShape3D.disabled = true
	else:
		$AreaSelected/CollisionShape3D.disabled = false
	if dragging_access and Global.currently_are_selecting:
		# Rotasi RayCast3D hanya di sumbu Y untuk menghadap mouse_pos
		
		if pinned_position != Vector3.ZERO:
			target_pos = pinned_position
		else:
			target_pos = Global.mouse_pos
		
		direction = (target_pos - drag_to.global_position).normalized()
		look_rotation = Vector3(0, atan2(direction.x, direction.z), 0)
		drag_to.rotation = look_rotation
		# Panjang target_position sesuai jarak dari raycast ke mouse_pos
		distance = drag_to.global_position.distance_to(target_pos)
		distance_square = distance/2
		drag_to.target_position = Vector3(0, 0, distance_square)
		scaler.scale.y = -distance_square
		distribute_path.curve.set_point_position(1, Vector3(distance_square,0,0))
		distribute_path.curve.set_point_out(0, Vector3(distance_square/2, height_curve+(distance_square/3), 0))
		# Gerakkan area_selected ke posisi mouse (X dan Z saja)
		area_selected.global_position.x = Global.mouse_pos.x
		area_selected.global_position.z = Global.mouse_pos.z

		# Reset posisi jika mouse kiri dilepas
		if Input.is_action_just_released("mouse_selected"):
			if pinned_position == Vector3.ZERO:
				_reset_drag()
			else:
				area_selected.position = Vector3(0,0.75,0)
				dragging_access = false
				Global.currently_are_selecting = false
	if area_selected.target != null:
		target_send = area_selected.target

func _reset_drag()->void:
	dragging_access = false
	Global.currently_are_selecting = false
	drag_to.visible = false
	# Reset posisi semua
	area_selected.position = Vector3(0,0.75,0)
	drag_to.target_position = Vector3.ZERO
	drag_to.rotation = Vector3.ZERO
	pinned_position = Vector3.ZERO
	distance = 0
	scaler.scale.y = 0.065
	distribute_path.curve.set_point_position(1, Vector3(0.04,0,0))
	if area_selected.target != null:
		# Hapus koneksi dua arah
		if target_send.list_node_tersambung.has(self):
			target_send.list_node_tersambung.erase(self)
		if list_node_tersambung.has(target_send):
			list_node_tersambung.erase(target_send)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if Global.currently_are_delete == false:
			if event.button_index == MOUSE_BUTTON_LEFT and pinned_position == Vector3.ZERO:
				if not dragging_access and not Global.currently_are_selecting:
					dragging_access = true
					drag_to.visible = true
					Global.currently_are_selecting = true
				else:
					dragging_access = false
					drag_to.visible = false
					Global.currently_are_selecting = false
					pinned_position = Vector3.ZERO
		else:
			#menghapus diri sendiri
			if event.button_index == MOUSE_BUTTON_LEFT:
				var copy = list_node_tersambung.duplicate()
				for node in copy:
					#print(node)
					if node.has_method("_reset_drag"):
						node._reset_drag()
					elif node.has_method("_reset_drag_multiple"):
						node._reset_drag_multiple(self)
				#deleting line
				_reset_drag()
				
				queue_free()
			
	if Global.currently_are_selecting and not dragging_access:
		visited += 1

func _on_interact_to_line_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and Global.currently_are_delete == true:
		drag_to.visible = false
		_reset_drag()
