extends Control

@export var main_menu: String # Bisa diganti ke Main Menu atau Credits

# Dictionary untuk menampung array dialog & speaker berdasarkan kondisi
# Atau kamu bisa pakai enum/export terpisah
@export_enum("Win", "Lose", "Neutral") var ending_condition: int = 0
# --- DATA DIALOG (GOOD, NEUTRAL, BAD ENDING) ---

var win_dialogs: Array[String] = [
	"Masa jabatan Anda resmi berakhir hari ini, Bapak Wali Kota.",
	"Saya harus mengakui, kepemimpinan Anda sungguh luar biasa. Anda berhasil membuktikan bahwa pertumbuhan ekonomi dan kelestarian lingkungan bisa berjalan berdampingan di Sampahnesia.",
	"Sampah yang dulunya menjadi masalah besar, kini justru menjadi penggerak roda ekonomi warga. Kota kita hijau, asri, dan masyarakat hidup dengan sejahtera.",
	"Ini semua berkat kerja sama seluruh warga dan arahan dari Anda juga, Bu Sekda.",
	"Suatu kehormatan bagi saya dapat mendampingi Anda. Nama Anda akan selalu dikenang sebagai pemimpin yang membawa keajaiban bagi Sampahnesia.",
	"Selamat atas purna tugas Anda, Bapak Wali Kota."
]
var win_speakers: Array[String] = ["Sekretaris", "Sekretaris", "Sekretaris", "Pemain", "Sekretaris", "Sekretaris"]

var neutral_dialogs: Array[String] = [
	"Waktu berjalan begitu cepat. Hari ini adalah hari terakhir masa jabatan Anda sebagai Wali Kota.",
	"Selama masa kepemimpinan Anda, Sampahnesia mengalami banyak perubahan. Perekonomian berjalan cukup stabil dan kebutuhan dasar warga dapat terpenuhi.",
	"Meskipun masalah penumpukan sampah dan tingkat polusi belum sepenuhnya teratasi dengan sempurna, setidaknya kota ini tidak jatuh ke dalam krisis.",
	"Masih banyak hal yang ingin saya benahi, namun waktu kita terbatas.",
	"Apa yang telah Anda capai sudah cukup baik, Pak. Anda telah meletakkan fondasi awal yang lumayan untuk pemimpin berikutnya.",
	"Terima kasih atas kerja keras Anda selama ini untuk Sampahnesia. Selamat purna tugas."
]
var neutral_speakers: Array[String] = ["Sekretaris", "Sekretaris", "Sekretaris", "Pemain", "Sekretaris", "Sekretaris"]

var lose_dialogs: Array[String] = [
	"Masa jabatan Anda telah resmi berakhir, Bapak Wali Kota.",
	"Sayang sekali, kondisi Sampahnesia saat ini jauh dari kata baik. Tumpukan sampah kian meluap dan tingkat polusi udara sudah berada di tahap yang membahayakan warga.",
	"Eksploitasi lahan tanpa penanaman kembali membuat kota ini kehilangan ruang hijaunya. Banyak warga yang mengeluhkan kondisi lingkungan kita saat ini.",
	"Saya... saya terlalu fokus pada pembangunan hingga mengabaikan dampaknya...",
	"Pembangunan tanpa menjaga keseimbangan alam hanya akan membawa kehancuran, Pak. Ini menjadi pelajaran yang sangat mahal bagi kita semua.",
	"Mobil penjemputan Anda sudah siap di depan. Terima kasih atas pengabdian Anda..."
]
var lose_speakers: Array[String] = ["Sekretaris", "Sekretaris", "Sekretaris", "Pemain", "Sekretaris", "Sekretaris"]

# Variabel aktif yang akan digunakan berdasarkan ending_condition
var active_dialogs: Array[String] = []
var active_speakers: Array[String] = []

var dialog_count: int = 0
var is_transitioning: bool = true

# MULAI #
func _ready() -> void:
	ending_condition = Global.ending_id
	# 1. Tentukan data mana yang dipakai berdasarkan pilihan di Inspector atau Global
	setup_ending_data()
	
	%DialogControl.show()
	%Dialog.show()
	
	start_cutscene()

# Menentukan data dialog berdasarkan kondisi
func setup_ending_data() -> void:
	match ending_condition:
		0: # Win
			active_dialogs = win_dialogs
			active_speakers = win_speakers
		1: # Lose
			active_dialogs = lose_dialogs
			active_speakers = lose_speakers
		2: # Neutral
			active_dialogs = neutral_dialogs
			active_speakers = neutral_speakers

func start_cutscene() -> void:
	play_sound()
	change_dialog()
	is_transitioning = false

# GANTI TEKS #
func _input(event: InputEvent) -> void: 
	if Input.is_action_just_pressed("ui_accept"): 
		condition_change_dialog() 
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			condition_change_dialog()

func change_dialog() -> void:	
	if dialog_count < active_dialogs.size():
		%Nama.text = str(active_speakers[dialog_count])
		%Dialog.text = str(active_dialogs[dialog_count])
		
		match %Nama.text:
			"Pemain":
				$AnimationPlayer.play("walikota_speak")
			"Sekretaris":
				$AnimationPlayer.play("sekretaris_speak")
			"-":
				$AnimationPlayer.play("typing")
		
		dialog_count += 1
	else:
		selesai()

# KONDISI #
func condition_change_dialog() -> void:
	if is_transitioning:
		return

	if %Dialog.visible_ratio < 1.0:
		$AnimationPlayer.seek($AnimationPlayer.current_animation_length)
		$TypingSFX.stop()
		$TypingTimer.stop()
	else:
		play_sound()
		change_dialog()

# SUARA #
func play_sound() -> void:
	$TypingSFX.play()
	$TypingTimer.start(2.0)

func _on_typing_timer_timeout():
	$TypingSFX.stop()

# SELESAI #
func _on_button_pressed() -> void:
	selesai()
	
func selesai() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	$TypingSFX.stop()
	$AnimationPlayer.play("fade-out")
	Global.on_tutorial = false
	await $AnimationPlayer.animation_finished
	Transition.change_scnee(main_menu)
	#OS.shell_open("https://forms.gle/xucovEAZ8P6keA7AA")
