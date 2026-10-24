extends Node3D
var flooding_wait_time: float = 10.0

var jumlah_sampah_terpanggil: int = 0
var maximum_sampah: int = 15
@export var udara_pohon: int = 2
@export var pollution_bar: ProgressBar 

# Asumsi node Sampah_added ada di dalam scene utama sebagai child node
@onready var sampah_added_node = $Sampah_added 

func _ready() -> void:
	$Island/AnimationPlayer.play("scneery")
	$CameraPosition.send_month.connect(adding_sampah)
	update_polution_bar()
	Global.stat_oxigen += udara_pohon * $StarterNature.get_child_count()

func adding_sampah(_month: int) -> void:
	# 1. Hitung berapa banyak sampah yang saat ini aktif di dalam game (berdasarkan target_spawn)
	var sampah_aktif = 0
	if sampah_added_node and sampah_added_node.target_spawn != null:
		sampah_aktif = sampah_added_node.target_spawn.get_child_count()
	
	# 2. Hitung sisa kuota yang masih boleh di-spawn agar tidak melewati maximum_sampah (15)
	var sisa_kuota = maximum_sampah - sampah_aktif
	
	if sisa_kuota <= 0:
		print("Kapasitas sampah sudah penuh (15/15). Tidak ada sampah baru yang di-spawn bulan ini.")
		return

	# 3. Batasi jumlah sampah yang akan dimasukkan ke antrian agar tidak melebihi sisa kuota
	var sampah_tambah = min(jumlah_sampah_terpanggil, sisa_kuota)
	
	# 4. Masukkan ke antrian Sampah_added jika ada jumlah yang valid
	if sampah_tambah > 0:
		sampah_added_node.antrian_sampah = sampah_tambah
		print("Bulan berganti. Menambahkan antrian sampah sebanyak: ", sampah_tambah, " (Total aktif: ", sampah_aktif, ")")
	else:
		print("Tingkat polusi rendah, tidak ada sampah baru bulan ini.")

func _on_nature_child_entered_tree(_node: Node) -> void:
	Global.stat_oxigen += udara_pohon
	update_polution_bar()

func _on_nature_child_exiting_tree(_node: Node) -> void:
	Global.stat_oxigen -= udara_pohon
	update_polution_bar()

func _on_starter_nature_child_exiting_tree(_node: Node) -> void:
	Global.stat_oxigen -= udara_pohon
	update_polution_bar()	
func _on_bangunan_child_entered_tree(node: Node) -> void:
	Global.stat_polution += node.jumlah_polusi
	update_polution_bar()

func _on_bangunan_child_exiting_tree(node: Node) -> void:
	Global.stat_polution -= node.jumlah_polusi
	update_polution_bar()

func _on_sampah_child_entered_tree(node: Node) -> void:
	Global.stat_polution += node.jumlah_polusi
	update_polution_bar()

func _on_sampah_child_exiting_tree(node: Node) -> void:
	Global.stat_polution -= node.jumlah_polusi
	update_polution_bar()




func update_polution_bar() -> void:
	if not is_inside_tree() or pollution_bar == null:
		return
		
	var max_fog_density: float = 0.01
	var fog_dense_value: float 
	
	pollution_bar.max_value = Global.stat_oxigen + Global.stat_polution
	pollution_bar.value = Global.stat_oxigen
	fog_dense_value = remap(Global.stat_polution, 0.0, pollution_bar.max_value, 0.0, max_fog_density)
	
	# Tentukan target fog density berdasarkan tingkat polusi
	var target_fog_density: float = 0.0
	
	if fog_dense_value < max_fog_density * 0.2:
		# Sangat cerah
		target_fog_density = max_fog_density * 0.0
		jumlah_sampah_terpanggil = 0
		flooding_wait_time = 8.0
	elif fog_dense_value < max_fog_density * 0.4:
		# Cerah
		target_fog_density = max_fog_density * 0.2
		jumlah_sampah_terpanggil = 1
		flooding_wait_time = 5.0
	elif fog_dense_value < max_fog_density * 0.6:
		# Sedang
		target_fog_density = max_fog_density * 0.6
		jumlah_sampah_terpanggil = 3
		flooding_wait_time = 2.0
	elif fog_dense_value < max_fog_density * 0.8:
		# Buruk
		target_fog_density = max_fog_density * 0.8
		jumlah_sampah_terpanggil = 4
		flooding_wait_time = 1.0
	elif fog_dense_value <= max_fog_density * 1.0:
		# Sangat buruk
		target_fog_density = max_fog_density * 1.0
		jumlah_sampah_terpanggil = 5
		flooding_wait_time = 0.5
	else:
		print("Nilai di luar jangkauan:", fog_dense_value)
		return

	# --- MEMBUAT TRANSISI HALUS MENGGUNAKAN TWEEN ---
	terapkan_transisi_fog(target_fog_density)

# Fungsi bantu untuk menganimasikan perubahan fog density
func terapkan_transisi_fog(target_value: float) -> void:
	if %WorldEnvironment.environment == null:
		return
		
	# Buat tween baru (pastikan menghentikan tween lama jika ada yang sedang berjalan)
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Tween properti fog_density milik environment dari nilai saat ini ke target_value dalam 1.5 detik
	tween.tween_property(
		%WorldEnvironment.environment, 
		"fog_density", 
		target_value, 
		0.5 # Durasi transisi dalam detik (bisa diubah sesuai keinginan)
	)
