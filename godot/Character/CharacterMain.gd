extends CharacterBody3D

@onready var nav_agent = $Navigation

var SPEED = 5.0
var has_target = false
var hunger = 100
var health = 100
@onready var bar = $HealthBar3D

func _ready():
	update_target_location(get_random_near_location())
	has_target = true

func _physics_process(delta):
	bar.update(hunger, 100)
	var current_location = global_transform.origin
	if (has_target == true):
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity = new_velocity
		move_and_slide()
	else:
		update_target_location(get_random_near_location())
		has_target = true

func get_random_near_location():
	SPEED = 20 / sqrt(hunger)
	var x = 0 + global_transform.origin.x/2 + randf_range(-10, 10)
	var y = global_transform.origin.y
	var z = 0 + global_transform.origin.z/2 + randf_range(-10, 10)
	
	#x += randf_range(-20 / sqrt(hunger), 20 / sqrt(hunger))
	#z += randf_range(-20 / sqrt(hunger), 20 / sqrt(hunger))
	
	return Vector3(x, y, z)

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)


func _on_navigation_navigation_finished():
	has_target = false


func _on_tick_timeout():
	if(hunger > 0):
		hunger -= 1
	if(hunger <= 0):
		queue_free()
