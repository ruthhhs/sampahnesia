extends Marker2D

func _on_rotation_button_pressed() -> void:
	# Merotasi seluruh Marker2D (dan anak-anak pipanya) sebesar 90 derajat
	rotation += deg_to_rad(90)
