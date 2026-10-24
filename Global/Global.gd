extends Node

var name_city: String = "sampahnesia"
var mouse_pos: Vector3

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
			if stat_money >= 5000:
				Archivement.validate_archivement(3)
			if stat_money >= 10000:
				Archivement.validate_archivement(4)

var stat_polution: int = 1
var stat_oxigen: int = 1
var repairement_unused: int = 3

# --- FUNGSI RESET GLOBAL ---
func reset_game_data() -> void:
	name_city = "sampahnesia"
	mouse_pos = Vector3.ZERO
	
	# Reset state (akan otomatis memicu signal jika nilainya berubah)
	currently_are_inspecting = false
	currently_are_selecting = false
	currently_are_delete = false
	currently_are_raining = false
	
	# Reset statistik game
	stat_money = 0
	stat_polution = 1
	stat_oxigen = 1
	repairement_unused = 3
	
	# Panggil reset pada Autoload Archivement
	if Archivement.has_method("reset_archivement"):
		Archivement.reset_archivement()
