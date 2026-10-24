extends Node

# Signal yang akan dipancar saat ada achievement yang terbuka
signal achievement_unlocked(uid: int, title: StringName, reward: int)
signal achievement_status_changed(uid: int, new_status: bool)

# List of data
var title_archivement: Array[StringName] = [
	"Awal Peradaban", "Penyemai Hayati", "Percikan Kehidupan",
	"Langkah Finansial", "Pundi Melimpah", "Arsitek Industri",
	"Jaringan Megawatt", "Mega Industri", "Tanpa Kegelapan",
	"Banjir !!!", "Restorasi Total", "Surga Tanpa Polusi"
]

var task_archivement: Array[String] = [
	"Membangun 1 Bangunan Produksi", "Menanam 10 pohon", "Membangun 1 Pembangkit Listrik",
	"Mencapai 5000 dolar pertama", "Mencapai 10000 dolar pertama", "Membangun 5 bangunan produksi",
	"Membangun 5 pembangkit listrik", "Membangun 15 bangunan Produksi", "Membangun 10 pembangkit listrik",
	"Mengalami Banjir", "Memperbaiki Bangunan", "Udara Bersih Total"
]

var status_archivement: Array[bool] = [
	false, false, false, false, false, false,
	false, false, false, false, false, false
]

var reward_archivement: Array[int] = [
	2000, 2000, 2000, 2000, 2000, 2000,
	2000, 2000, 2000, 2000, 2000, 2000
]

func validate_archivement(uid_archivement: int) -> void:
	# Cek apakah index valid (di dalam jangkauan array)
	if uid_archivement >= 0 and uid_archivement < status_archivement.size():
		# Hanya ubah & emit jika statusnya masih false
		if not status_archivement[uid_archivement]:
			status_archivement[uid_archivement] = true
			
			# Emit signal perubahan status
			achievement_status_changed.emit(uid_archivement, true)
			
			# Emit signal detail achievement (cocok untuk pemicu notifikasi UI)
			achievement_unlocked.emit(
				uid_archivement, 
				title_archivement[uid_archivement], 
				reward_archivement[uid_archivement]
			)
