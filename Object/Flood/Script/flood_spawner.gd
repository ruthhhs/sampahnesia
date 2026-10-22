extends Node3D
var water_flood_size_limit: Vector2 = Vector2 (0.5,1.5)
var limit_flood: Vector2 = Vector2(5,8)#x as minimum || y as maximum
var offset_up: int = 10
var generate_vector_bound: Vector2 
var generate_limit_vector: Vector2 = Vector2(15,30) #x as minimum || y as maximum
var random: RandomNumberGenerator = RandomNumberGenerator.new()
var flood = preload("res://Object/Flood/water_flood.tscn")

func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	generate_vector_bound = Vector2(random.randi_range(generate_limit_vector.x,generate_limit_vector.y),random.randi_range(generate_limit_vector.x,generate_limit_vector.y))
	%RayCastUpRight.position = Vector3(generate_vector_bound.x,1,-generate_vector_bound.y)
	%RayCastDownRight.position = Vector3(generate_vector_bound.x,1,generate_vector_bound.y)
	%RayCastUpLeft.position = Vector3(-generate_vector_bound.x,1,-generate_vector_bound.y)
	%RayCastDownLeft.position = Vector3(-generate_vector_bound.x,1,generate_vector_bound.y)
	#if %RayCastDownLeft.is_colliding() and %RayCastDownRight.is_colliding() and %RayCastUpLeft.is_colliding() and %RayCastUpRight.is_colliding():
	
func generate_flood()->void:
	var total_flood: int 
	@warning_ignore("narrowing_conversion")
	total_flood = random.randi_range(limit_flood.x,limit_flood.y)
	spawning_flood()
	#for i in range(%Flood.get_child_count()):
		#%Flood.get_child(i).queue_free()
	for i in range(total_flood):
		spawning_flood()
func spawning_flood()->void:
	var flood_instanciate = flood.instantiate()
	var flood_size_hasil = randf_range(water_flood_size_limit.x,water_flood_size_limit.y) 
	flood_instanciate.scale = Vector3(flood_size_hasil,1,flood_size_hasil)
	flood_instanciate.position = Vector3(position.x + random.randf_range(generate_vector_bound.x,-generate_vector_bound.x),0,position.z + random.randf_range(generate_vector_bound.y,-generate_vector_bound.y))
	get_parent().add_child(flood_instanciate)
	queue_free()


func _on_timer_timeout() -> void:
	
	#print(%RayCastDownLeft.is_colliding(),%RayCastDownRight.is_colliding(),%RayCastUpLeft.is_colliding(),%RayCastUpRight.is_colliding())#pass
	if %RayCastDownLeft.is_colliding() == true and %RayCastDownRight.is_colliding() == true and %RayCastUpLeft.is_colliding() == true and %RayCastUpRight.is_colliding() == true:
		generate_flood()
	else:
		queue_free()
