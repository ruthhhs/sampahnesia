extends Timer



func _on_timeout() -> void:
	var parent = get_parent()
	if parent:
		# Cek apakah nilai saat ini sudah mencapai atau melebihi batas maksimum
		if parent.item_value >= parent.maximum_item_value:
			stop() # Menghentikan Timer
			# queue_free() # Uncomment jika ingin nodenya langsung dihapus
		else:
			parent.item_value += 5
			
			# Pengecekan ekstra setelah ditambah, jika tembus batas, set ke max & stop timer
			if parent.item_value >= parent.maximum_item_value:
				parent.item_value = parent.maximum_item_value
				stop()
