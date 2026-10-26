extends Node3D

enum BuildingCategory {
	SAMPAH,
	PERTANIAN,
	PETERNAKAN,
	TOKO
}

@export var building_category: BuildingCategory = BuildingCategory.SAMPAH

var parent_building: Building


func _ready() -> void:
	if _is_already_connected_globally():
		queue_free()
		return

	if get_parent() is Building:
		parent_building = get_parent() as Building
		parent_building.outbound_connection_changed.connect(_on_outbound_changed)
	else:
		push_warning("Node first_connector harus ditempatkan sebagai child dari prototype_listrik (Building)!")


func _on_outbound_changed(count: int, _targets: Array[Area3D]) -> void:
	if count > 0:
		_trigger_first_connection()


func _trigger_first_connection() -> void:
	match building_category:
		BuildingCategory.SAMPAH:
			Global.first_sampah_input = true
			print("Tutorial Event: Bangunan Sampah pertama kali terhubung!")
		BuildingCategory.PERTANIAN:
			Global.first_pertanian_input = true
			print("Tutorial Event: Pertanian pertama kali terhubung!")
		BuildingCategory.PETERNAKAN:
			Global.first_perternakan_input = true
			print("Tutorial Event: Peternakan pertama kali terhubung!")
		BuildingCategory.TOKO:
			Global.first_toko_input = true
			print("Tutorial Event: Toko pertama kali terhubung!")

	queue_free()


func _is_already_connected_globally() -> bool:
	match building_category:
		BuildingCategory.SAMPAH:
			return Global.first_sampah_input
		BuildingCategory.PERTANIAN:
			return Global.first_pertanian_input
		BuildingCategory.PETERNAKAN:
			return Global.first_perternakan_input
		BuildingCategory.TOKO:
			return Global.first_toko_input
	return false
