extends TextureRect

func _ready() -> void:
	# Sembunyikan indikator merah/notifikasi saat pertama kali game jalan
	hide()
	
	# Sambungkan signal 'pressed' dari parent (Button)
	var parent_button = get_parent() as Button
	if parent_button:
		parent_button.pressed.connect(_on_parent_pressed)
	
	# Sambungkan signal dari Autoload Archivement
	if Archivement.has_signal("achievement_status_changed"):
		Archivement.achievement_status_changed.connect(_on_achievement_updated)

# Dipanggil otomatis tiap ada update/pencapaian baru yang terbuka
func _on_achievement_updated(_uid: int, _new_status: bool) -> void:
	show()

# Dipanggil saat tombol parent diklik
func _on_parent_pressed() -> void:
	hide()
