extends Control

var is_complete: bool = false:
	set(value):
		if is_complete != value:
			is_complete = value
			if is_complete == true:
				queue_free()
