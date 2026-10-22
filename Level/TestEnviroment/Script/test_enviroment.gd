extends Node3D

@export var udara_pohon: int = 2
@export var pollution_bar: ProgressBar #= %PollutionBar#$CameraPosition/CanvasLayer/GameUIBuilder/CityStatsRight/VBoxContainer/HBoxContainer/PollutionBar 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Island/AnimationPlayer.play("scneery")
	#for i in range(%Bangunan.get_child_count()):
		#udara_kotor += %Bangunan.get_child(i).jumlah_polusi
	#udara_bersih += udara_bersih * %Nature.get_child_count()
	update_polution_bar()
func _on_nature_child_entered_tree(_node: Node) -> void:
	#udara_bersih += udara_pohon
	Global.stat_oxigen += udara_pohon
	update_polution_bar()
func _on_nature_child_exiting_tree(_node: Node) -> void:
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
	# Mencegah eksekusi jika node/UI belum siap (_ready belum dipanggil)
	if not is_inside_tree() or pollution_bar == null:
		return
		
	var max_fog_density: float = 0.01
	

	var fog_dense_value: float 
	pollution_bar.max_value = Global.stat_oxigen + Global.stat_polution
	pollution_bar.value = Global.stat_oxigen
	fog_dense_value = remap(Global.stat_polution,0.0,pollution_bar.max_value,0.0,max_fog_density)
	#print(Global.stat_oxigen)
	if fog_dense_value < max_fog_density * 0.2:
		#sangat cerah
		%WorldEnvironment.environment.fog_density = max_fog_density * 0.0
	elif fog_dense_value < max_fog_density * 0.4:
		#cerah
		%WorldEnvironment.environment.fog_density = max_fog_density * 0.2
	elif fog_dense_value < max_fog_density * 0.6:
		#sedang
		%WorldEnvironment.environment.fog_density = max_fog_density * 0.6
	elif fog_dense_value < max_fog_density * 0.8:
		#buruk
		%WorldEnvironment.environment.fog_density = max_fog_density * 0.8
	elif fog_dense_value <= max_fog_density * 1.0:
		#Sangat buruk
		%WorldEnvironment.environment.fog_density = max_fog_density * 1.0
	else:
		print("Nilai di luar jangkauan:", fog_dense_value)
	
