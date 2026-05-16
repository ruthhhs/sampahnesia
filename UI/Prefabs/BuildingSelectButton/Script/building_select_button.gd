extends Control

var offset_y: float = 30.0

@export var nama_bangunan: String
@export var gambar_bangunan: Texture2D
@export var using_electricity: bool = false
@export var gambar_input: Texture2D
@export var gambar_output: Texture2D
@export var price_bangunan: int = 1000
@export var id_building: int
@export var control_parent: Marker3D

func _ready() -> void:
	%Nama.text = str(nama_bangunan)
	%BuildingTexture.texture = gambar_bangunan
	%InputTexture.texture = gambar_input
	%OutputTexture.texture = gambar_output
	%InformationPanel.visible = false
	%PriceLabel.text = str(price_bangunan)
	%InformationPanel.position = Vector2(global_position.x-300.0/2,global_position.y-%InformationPanel.size.y)
	if using_electricity:
		%Adder.visible = true
		%Electricity.visible = true

	else:
		%Adder.visible = false
		%Electricity.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_mouse_entered() -> void:
	%InformationPanel.visible = true
	%InformationPanel.position = Vector2(global_position.x-28,global_position.y-%InformationPanel.size.y-offset_y)
func _on_button_mouse_exited() -> void:
	%InformationPanel.visible = false
	%InformationPanel.position = global_position

func _on_button_pressed() -> void:
	control_parent.id_input = id_building
	control_parent.input_price = price_bangunan
