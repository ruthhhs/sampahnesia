extends ScrollContainer
@onready var archivement_node:= preload("res://Controller/CameraController/archivement.tscn")
func _ready() -> void:
	Archivement.achievement_unlocked.connect(_on_achievement_unlocked)

func _on_achievement_unlocked(uid: int, title: StringName, reward: int) -> void:
	var archivement_node_instanciate := archivement_node.instantiate()
	archivement_node_instanciate.archivement_title = title
	archivement_node_instanciate.explain= Archivement.task_archivement[uid]
	$VBoxArchivement.add_child(archivement_node_instanciate)
