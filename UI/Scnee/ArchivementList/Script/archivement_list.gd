extends Control

@onready var list_of_archivement_panel: VBoxContainer = $PanelContainer/VBoxContainer/VBoxContainer/ListofArchivementPanel
@onready var archivement_panel := preload("res://UI/Scnee/ArchivementList/archivement_panel.tscn")

func _ready() -> void:
	for i in range(Archivement.title_archivement.size()):
		var instance = archivement_panel.instantiate()
		instance.uid = i # Berikan UID sebelum add_child
		list_of_archivement_panel.add_child(instance)


func _on_exit_button_pressed() -> void:
	visible = false
