extends Node3D

@onready var bangunan_sampah := preload("res://Object/Sampah/bangunan_sampah.tscn")
@export var kapasitasi_maksimum_sampah: int = 15
@export var target_spawn: Node3D 
@export var antrian_sampah: int = 0:
	set(value):
		var nilai_lama = antrian_sampah
		
		# Batasi agar nilai baru tidak membuat total sampah melebihi kapasitas maksimum
		var total_sampah_saat_ini = get_jumlah_sampah_aktif()
		var sisa_kapasitas = kapasitasi_maksimum_sampah - total_sampah_saat_ini
		
		# Clamp nilai antrian agar aman
		antrian_sampah = clamp(value, 0, sisa_kapasitas)
		
		# Jangan jalankan setter jika node belum masuk ke Scene Tree
		if not is_inside_tree():
			return
			
		# Jika sebelumnya antrian 0 dan sekarang bertambah, jalankan lagi proses spawn-nya
		if nilai_lama == 0 and antrian_sampah > 0:
			mulai_proses_spawn()

@export var maximum_pos_x: float = 204.249
@export var minimum_pos_x: float = -211.055
@export var maximum_pos_y: float = 157.79
@export var minimum_pos_y: float = -155.321

var hasil_asli: bool = false
var sedang_spawn: bool = false 

func _ready() -> void:
	if antrian_sampah > 0:
		mulai_proses_spawn()

func desicion_raycaster() -> bool:
	var hasil: bool = true
	for i in range($Raycaster.get_child_count()):
		var ray = $Raycaster.get_child(i)
		if ray is RayCast3D and not ray.is_colliding():
			hasil = false
			break
	return hasil

func _on_area_3d_area_entered(area: Area3D) -> void:
	if not area.is_in_group("collision_checkers"):
		hasil_asli = false

func _on_area_3d_area_exited(area: Area3D) -> void:
	if not area.is_in_group("collision_checkers"):
		hasil_asli = true

# Fungsi untuk menghitung berapa banyak sampah yang saat ini sudah ada di target_spawn
func get_jumlah_sampah_aktif() -> int:
	if target_spawn != null:
		return target_spawn.get_child_count()
	return 0

func mulai_proses_spawn() -> void:
	if sedang_spawn: 
		return
	sedang_spawn = true
	
	while antrian_sampah > 0:
		# Pengecekan ganda: Jika kapasitas maksimum sudah tercapai di tengah jalan, hentikan proses spawn
		if get_jumlah_sampah_aktif() >= kapasitasi_maksimum_sampah:
			#print("Kapasitas maksimum sampah tercapai! Spawn dihentikan.")
			antrian_sampah = 0 # Kosongkan sisa antrian
			break

		await cari_posisi_valid()
		
		var instans_sampah = bangunan_sampah.instantiate()
		
		if target_spawn != null:
			target_spawn.add_child(instans_sampah)
			instans_sampah.position = self.global_position
			# instans_sampah.scale = Vector3(1, 1, 1) # Uncomment jika ukuran masih bermasalah
			
		antrian_sampah -= 1
		#print("Sisa antrian sampah: ", antrian_sampah, " | Total sampah aktif: ", get_jumlah_sampah_aktif())
		
		await get_tree().create_timer(0.1).timeout

	sedang_spawn = false
	#print("Proses spawn selesai.")

func cari_posisi_valid() -> void:
	var posisi_valid: bool = false
	
	while not posisi_valid:
		var random_x = randf_range(minimum_pos_x, maximum_pos_x)
		var random_y = randf_range(minimum_pos_y, maximum_pos_y)
		
		self.global_position.x = random_x
		self.global_position.z = random_y 
		
		hasil_asli = true
		
		await get_tree().physics_frame
		await get_tree().physics_frame
		
		if hasil_asli and desicion_raycaster():
			posisi_valid = true
		else:
			posisi_valid = false

func _on_start_timeout() -> void:
	pass
