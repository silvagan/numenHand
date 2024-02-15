extends Node3D
var ball = preload("res://Ball/Ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#var instance = ball.instantiate()
	#add_child(instance)
	pass 

var location = Vector3()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	#var instance = ball.instantiate()
	#add_child(instance)
	pass

func spawn_ball():
	randomize()
	location.x = randf_range(-10, 10)
	location.z = randf_range(-10, 10)
	location.y = randf_range(5, 20)
	var instance = ball.instantiate()
	instance.set_position(location)
	add_child(instance)

func _on_timer_timeout():
	spawn_ball()

func get_random_child_location():
	randomize()
	var children = get_children()
	var i = get_child_count()
	if (i > 0):
		var chosen = children[randi() % children.size()]
		return chosen.global_transform.origin
	else:
		return Vector3(0,0,0)
