extends Control

@export_group("Konfigurasi Dasar")
@export var id_building: int
@export var nama_bangunan: String
@export var price_bangunan: int = 1000
@export var harga_beli_item: int
@export var control_parent: Marker3D
@export var offset_y: float = 300.0
@export var hoverd_disabled: bool = false

@export_group("Tekstur")
@export var gambar_bangunan: CompressedTexture2D
@export var gambar_input: CompressedTexture2D
@export var gambar_output: CompressedTexture2D

@export_group("Tipe Bangunan")
@export var is_building: bool = false
@export var is_generator_electric: bool = false
@export var is_store: bool = false

@export_group("Atribut Bangunan")
@export var is_selling_building: bool = false
@export var is_building_need_electric: bool = false
@export var is_generator_need_source: bool = false
# Catatan: Saya menyatukan is_level2_store dan is_store_level_2 menjadi satu variabel saja
@export var is_level_2: bool = false 

func _ready() -> void:
	setup_initial_ui()
	update_panel_visibility()
	Global.is_selecting.connect(reveal)
	visible= Global.currently_are_selecting
func reveal(is_reveal: bool)-> void:
	visible = is_reveal
# Dipisahkan ke fungsi sendiri agar _ready() tidak terlalu panjang
func setup_initial_ui() -> void:
	%Nama.text = nama_bangunan
	%BuildingTexture.texture = gambar_bangunan
	%InputTexture.texture = gambar_input
	%OutputTexture.texture = gambar_output
	%PriceLabel.text = str(price_bangunan)
	
	%InformationPanel.visible = false
	# Posisi panel lebih baik di-set saat hover saja agar akurat dengan ukuran layout akhir

func update_panel_visibility() -> void:
	# Menggunakan if-elif agar state tidak bertabrakan jika tidak sengaja tercentang dua
	if is_building:
		%PanelForBuilding.visible = true
		%PanelElectricity.visible = false
		%PanelStore.visible = false
		
		%Money.text = str(harga_beli_item)
		%OutputSell.texture = %OutputTexture.texture
		%InputTexture.visible = true
		%OutputTexture.visible = true
		%Forwad2.visible = true
		
		%Electricity.visible = is_building_need_electric
		%Adder.visible = is_building_need_electric
		
		%TokoLevel1.visible = !is_level_2
		%TokoLevel2.visible = is_level_2
		
	elif is_generator_electric:
		%PanelForBuilding.visible = false
		%PanelElectricity.visible = true
		%PanelStore.visible = false
		
		%ElectricityInputTexture.visible = is_generator_need_source
		%ForwadElectricity.visible = is_generator_need_source
		if is_generator_need_source:
			%ElectricityInputTexture.texture = gambar_input
			
	elif is_store:
		%PanelForBuilding.visible = false
		%PanelElectricity.visible = false
		%PanelStore.visible = true
		
		%TokoAdded1.visible = !is_level_2
		%TokoAdded2.visible = is_level_2

func _on_button_mouse_entered() -> void:
	if not hoverd_disabled:
		%InformationPanel.visible = true
		%InformationPanel.position = Vector2(
			global_position.x + ((size.x / 2) - (%InformationPanel.size.x / 2)),
			global_position.y - offset_y
		)

func _on_button_mouse_exited() -> void:
	if not hoverd_disabled:
		%InformationPanel.visible = false

func _on_button_pressed() -> void:
	if control_parent != null:
		# Menyimpan data ke parent
		control_parent.building_need_electicity = is_building_need_electric
		control_parent.id_input = id_building
		control_parent.input_price = price_bangunan
		control_parent.texture_input = %InputTexture.texture
		control_parent.texture_output = %OutputTexture.texture
		
		if is_selling_building:
			control_parent.harga_eceran = harga_beli_item
			#print("Harga beli barang: ", harga_beli_item, " | price_input: ", control_parent.harga_eceran)
