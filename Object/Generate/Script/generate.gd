extends Node3D

func _ready() -> void:
	search_match("tile_0")

func search_match(tile: String)->void:
	var file = FileAccess.open("res://JsonFile/tiles.json", FileAccess.READ)
	if file == null:
		print("Tidak bisa membuka file JSON")
		return

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var result = json.parse(json_string)

	if result != OK:
		print("Error parsing:", json.get_error_message())
		return

	var data = json.data
	
	var isi_matrix_kanan: Array[int]
	var isi_matrix_kiri: Array[int]
	var isi_matrix_atas: Array[int]
	var isi_matrix_bawah: Array
	if data.has(tile):
		var matrix = data[tile]
		print("Isi ",tile,": ")
		for i in matrix:
			print(i[0])
			print(i[2])
			isi_matrix_kanan.append(int(i[0]))
			isi_matrix_kiri.append(int(i[2]))
		print(isi_matrix_kanan)
		print(isi_matrix_kiri)
		#
		#print("\n")
		#for i in data:
			#print( i, ": " )
			#
			#for j in data[i]:
				#print(int(j[2]))

	else:
		print("tile_34 tidak ditemukan")
