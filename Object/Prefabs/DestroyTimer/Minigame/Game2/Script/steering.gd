extends Marker2D

var can_move: bool = false
var is_dragging: bool = false
var nilai_aktual_dam: float 
@export var rotation_speed: float = 15.0
@export var min_rotation_degrees: float = 0.0     # Batas minimal (misal: 0 derajat / tertutup)
@export var max_rotation_degrees: float = 360.0 * 8  # Batas maksimal (misal: 360 derajat / terbuka penuh)

# Menyimpan sudut mouse sebelumnya untuk menghitung selisih putaran
var last_mouse_angle: float = 0.0
# Akumulasi total putaran keran dalam radian
var accumulated_rotation: float = 0.0

func _input(event: InputEvent) -> void:
	if can_move and event.is_action_pressed("mouse_selected"):
		is_dragging = true
		last_mouse_angle = global_position.angle_to_point(get_global_mouse_position())
	elif event.is_action_released("mouse_selected"):
		is_dragging = false

func _process(delta: float) -> void:
	if is_dragging:
		# 1. Ambil sudut mouse saat ini
		var current_mouse_angle = global_position.angle_to_point(get_global_mouse_position())
		
		# 2. Hitung selisih sudut dari frame sebelumnya
		var delta_angle = wrapf(current_mouse_angle - last_mouse_angle, -PI, PI)
		
		# 3. Akumulasikan ke rotasi target sementara
		accumulated_rotation += delta_angle
		
		# 4. CAP / BATASI akumulasi rotasi agar tidak tembus batas min & max (dikonversi dulu ke derajat)
		var current_deg = rad_to_deg(accumulated_rotation)
		current_deg = clamp(current_deg, min_rotation_degrees, max_rotation_degrees)
		
		# Kembalikan lagi ke bentuk radian setelah dicap
		accumulated_rotation = deg_to_rad(current_deg)
		
		# Simpan sudut mouse saat ini untuk frame berikutnya
		last_mouse_angle = current_mouse_angle
		
	# 5. Terapkan rotasi secara mulus menuju akumulasi yang sudah dibatasi
	rotation = lerp_angle(rotation, accumulated_rotation, rotation_speed * delta)
	# (Opsional) Cek persentase bukaan keran berdasarkan batas min dan max
	var flow_intensity = inverse_lerp(min_rotation_degrees, max_rotation_degrees, rotation_degrees)
	
	# Menghitung persentase
	var persentase = snapped(flow_intensity * 100, 0.1)
	
	# Menghitung nilai aktual dari rentang 0 sampai 142.165 berdasarkan intensitas putaran
	var nilai_aktual = remap(flow_intensity, 0.0, 1.0, 0.0, 142.165)
	nilai_aktual_dam = snapped(nilai_aktual, 0.001) # Membulatkan ke 3 angka desimal agar rapi
	
	# Cetak gabungan informasi persentase dan nilai aktual
	print("Bukaan Air: ", persentase, "% | Nilai Aktual: ", nilai_aktual_dam)

func _on_interact_area_entered(area: Area2D) -> void:
	can_move = true

func _on_interact_area_exited(area: Area2D) -> void:
	can_move = false
