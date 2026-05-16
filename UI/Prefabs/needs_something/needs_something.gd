extends Sprite3D
# Di dalam Child
@export var image_input: Texture2D
func _ready() -> void:
	%ImageInput.texture = image_input
func _process(delta: float) -> void:
	get_parent_data() #harusnya ga gini
		
func get_parent_data():
	var p = get_parent()
	var image_input = p.get("item_value") # Menggunakan fungsi get() bawaan Godot
	var electricity = p.get("electric_item")
	var is_electricity_product = p.get("is_electric_production")
	var input_tex = p.get("input_texture")
	%ImageInput.texture = input_tex
	#print(image_input," | ", electricity, " | ", is_electricity_product)
	if image_input > 0:
		%ImageInput.visible = false
	else:
		%ImageInput.visible = true
	
	if electricity > 0 or  is_electricity_product == true:
		%Electricity.visible = false
	else:
		%Electricity.visible = true
	if %Electricity.visible == false and %ImageInput.visible == false:
		visible = false
	else:
		visible = true
