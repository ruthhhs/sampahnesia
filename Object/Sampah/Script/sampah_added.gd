extends Node3D

@onready var bangunan_sampah := preload("res://Object/Sampah/bangunan_sampah.tscn")
@export var target_spawn: Node3D # Tempat atau parent node untuk spawn bangunan
@export var antrian_sampah: int = 4
@export var maximum_pos_x: float = 204.249
@export var minimum_pos_x: float = -211.055
@export var maximum_pos_y: float = 157.79
@export var minimum_pos_y: float = -155.321

var hasil_asli: bool = false

func _ready() -> void:
	# Memulai proses spawn otomatis saat node siap (atau bisa dipicu dari _on_start_timeout)
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
	# Jika area bertabrakan dengan sesuatu selain "collision_checkers"
	if not area.is_in_group("collision_checkers"):
		hasil_asli = false

func _on_area_3d_area_exited(area: Area3D) -> void:
	# Opsional: Reset kembali status jika keluar dari area terlarang
	if not area.is_in_group("collision_checkers"):
		hasil_asli = true

func mulai_proses_spawn() -> void:
	while antrian_sampah > 0:
		await cari_posisi_valid()
		
		var instans_sampah = bangunan_sampah.instantiate()
		
		if target_spawn != null:
			
			target_spawn.add_child(instans_sampah)
			instans_sampah.position = self.global_position
			#instans_sampah.global_transform = self.global_transform
		antrian_sampah -= 1
		print("Sisa antrian sampah: ", antrian_sampah)
		
		await get_tree().create_timer(0.1).timeout

	print("Semua antrian sampah telah habis dan berhasil di-spawn!")

func cari_posisi_valid() -> void:
	var posisi_valid: bool = false
	
	while not posisi_valid:
		# Generate posisi random X dan Y (menggunakan sumbu Z tetap atau sesuaikan dengan kebutuhan game Anda)
		var random_x = randf_range(minimum_pos_x, maximum_pos_x)
		var random_y = randf_range(minimum_pos_y, maximum_pos_y)
		
		# Ubah posisi node saat ini ke koordinat random baru
		# Catatan: Jika game Anda 3D top-down / datar di bidang X-Z, sesuaikan koordinat Y ke Z.
		self.global_position.x = random_x
		self.global_position.z = random_y # Ubah ke .z jika Y adalah ketinggian (altitude)
		
		# Reset status awal area sebelum dicek ulang
		hasil_asli = true
		
		# Tunggu 1-2 frame physics agar Area3D dan RayCast3D mendeteksi kondisi sekitar
		await get_tree().physics_frame
		await get_tree().physics_frame
		
		# Cek apakah lolos kedua syarat: Area3D aman (hasil_asli == true) dan semua Raycast menyentuh tanah (true)
		if hasil_asli and desicion_raycaster():
			posisi_valid = true
		else:
			posisi_valid = false

func _on_start_timeout() -> void:
	# Fungsi ini bisa dibiarkan atau dipicu manual
	pass
