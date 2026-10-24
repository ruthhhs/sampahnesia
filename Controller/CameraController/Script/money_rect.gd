extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.money_change.connect(money_flow)
func money_flow(_money:int)->void:
	$AnimationPlayer.play("money")
