extends Node3D
var ball = preload("res://Ball/Ball.tscn")

var location = Vector3()
func spawn_ball():
	randomize()
	location.x = randf_range(-50, 50)
	location.z = randf_range(-50, 50)
	location.y = randf_range(5, 20)
	var instance = ball.instantiate()
	instance.set_position(location)
	add_child(instance)

func get_random_child_location():
	randomize()
	var children = get_children()
	var i = get_child_count()
	if (i > 0):
		var chosen = children[randi() % children.size()]
		return chosen.global_transform.origin
	else:
		return Vector3(0,0,0)


func _on_food_spawn_timer_timeout():
		spawn_ball()
