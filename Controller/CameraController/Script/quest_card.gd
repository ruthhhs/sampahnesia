extends PanelContainer
@onready var examine_quest: Label = $HBoxContainer/ExamineQuest
@export var text_yang_mau_dimasukkin: String = " test 1 2 3"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	examine_quest.text = str(text_yang_mau_dimasukkin)
	visible = false
func _activate()-> void:
	visible = true
	$QuestAnim.play("added")
	
func _deactivate() -> void:
	$QuestAnim.play("delisted")


func _on_quest_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "delisted":
		queue_free()
