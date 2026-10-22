extends Timer




func _on_timeout() -> void:
	if get_parent().item_value <= get_parent().maximum_item_value:
		get_parent().item_value += 5
	else:
		queue_free()
