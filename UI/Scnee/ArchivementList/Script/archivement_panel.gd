extends PanelContainer

var uid: int

@onready var title: Label = $HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Title
@onready var desc_rich: RichTextLabel = $HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Desc
@onready var money_button: Button = $HBoxContainer/VBoxContainer2/TambahDuit

func _ready() -> void:
	title.text = Archivement.title_archivement[uid]
	desc_rich.text = Archivement.task_archivement[uid]
	
	# Connect signal dari Autoload Archivement agar update real-time
	if Archivement.has_signal("achievement_status_changed"):
		Archivement.achievement_status_changed.connect(_on_achievement_status_changed)
	
	update_ui()

# Fungsi untuk memperbarui status tombol
func update_ui() -> void:
	var is_unlocked: bool = Archivement.status_archivement[uid]
	var is_claimed: bool = Archivement.claimed_archivement[uid]
	
	if is_claimed:
		money_button.text = "Klaim"
		money_button.disabled = true
	elif is_unlocked:
		money_button.text = "+ " + str(Archivement.reward_archivement[uid])
		money_button.disabled = false
	else:
		money_button.text = "+ " + str(Archivement.reward_archivement[uid])
		money_button.disabled = true

# Dipanggil otomatis ketika ada pencapaian yang baru terbuka
func _on_achievement_status_changed(changed_uid: int, _new_status: bool) -> void:
	if changed_uid == uid:
		update_ui()

func _on_tambah_duit_pressed() -> void:
	if not Archivement.claimed_archivement[uid]:
		Global.stat_money += Archivement.reward_archivement[uid]
		Archivement.claimed_archivement[uid] = true # Tandai sudah diklaim
		update_ui()
