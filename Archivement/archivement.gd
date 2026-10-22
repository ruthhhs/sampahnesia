extends Node
# mereka akan call

#List of data
var title_archivement: Array[StringName] = ["Awal Peradaban",
"Penyemai Hayati",
"Percikan Kehidupan",
"Langkah Finansial", 
"Pundi Melimpah", 
"Arsitek Industri",
"Jaringan Megawatt", 
"Mega Industri", 
"Tanpa Kegelapan",
"Banjir !!!", 
"Restorasi Total", 
"Surga Tanpa Polusi"]

var task_archivement: Array[String] = ["Membangun 1 Bangunan Produksi",
"Menanam 10 pohon",
"Membangun 1 Pembangkit Listrik",
"Mencapai 5000 dolar pertama",
"Mencapai 10000 dolar pertama",
"Membangun 5 bangunan produksi",
"Membangun 5 pembangkit listrik",
"Membangun 15 bangunan Produksi",
"Membangun 10 pembangkit listrik",
"Mengalami Banjir",
"Memperbaiki Bangunan",
"Udara Bersih Total"]
var status_archivement: Array[bool] = [false,false,false,false,false,false,false,false,false,false,false,false]
var reward_archivement: Array[int] = [2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000]
#Validate function
#func _ready() -> void:
	#print("title size: ", title_archivement.size(), " | ",
	#"task size: ", task_archivement.size()," | ",
	#"status size: ", status_archivement.size()," | ",
	#"reward size: ", reward_archivement.size()," | ",
	#)
func validate_archivement(uid_archivement: int) -> void:
	if status_archivement.size() <= uid_archivement:
		if status_archivement[uid_archivement] == false:
			print("Added")
			status_archivement[uid_archivement] = true
