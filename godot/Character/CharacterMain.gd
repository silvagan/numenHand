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
	var lookdir = atan2(-velocity.x, -velocity.z)
	rotation.y = lookdir
	bar.update(hunger, 100)
	var current_location = global_transform.origin
	if (has_target == true):
		look_at_target(nav_agent.target_position)
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity = new_velocity
		move_and_slide()
	else:
		update_target_location(get_random_near_location())
		has_target = true

func get_random_near_location():
	SPEED = 20 / sqrt(hunger)
	var x = global_transform.origin.x
	var z = global_transform.origin.z
	
	x += randf_range(-10, 10)
	z += randf_range(-10, 10)
	var y = global_transform.origin.y
	
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

func _on_vision_timer_timeout():
	if (has_target == true):
		pass
	var overlaps = $Body/Head/VisionCones.get_overlapping_bodies()
	print(str(overlaps.size()) + " objects in view")
	if overlaps.size() > 0:
		if (contains_food(overlaps) == true && hunger <= 70):
			get_closest(overlaps)
			has_target = true
		pass
	pass

func contains_food(all):
	for c in all:
		if(c.is_in_group("food") && is_visible_from_view(c.global_transform.origin)):
			return true

func get_first_food(all):
	for c in all:
		if (c.is_in_group("food") && is_visible_from_view(c.global_transform.origin)):
			return c

func get_closest(all):
	var m = get_first_food(all)
	for c in all:
		if (c.is_in_group("food") && is_visible_from_view(c.global_transform.origin)):
			var c1 = diff(c)
			var c2 = diff(m)
			if (c1 < c2):
				m = c
	update_target_location(m.global_position)
	SPEED = 5.0

func get_closest_in_range(range):
	var food = get_tree().get_nodes_in_group("food")
	pass

func diff(ob):
	var x1 = self.global_position.x
	var y1 = self.global_position.y
	var z1 = self.global_position.z
	var x2 = ob.global_position.x
	var y2 = ob.global_position.y
	var z2 = ob.global_position.z
	var s1 = abs(x1-x2)
	var s2 = abs(y1-y2)
	var s3 = abs(z1-z2)
	return s1 + s2 + s3

func look_at_target(target):
	$Body/Head.look_at(target, Vector3.UP)

func is_visible_from_view(target):
	$Body/Head/VisionRayCast.look_at(target, Vector3.UP)
	$Body/Head/VisionRayCast.force_raycast_update()
	
	if $Body/Head/VisionRayCast.is_colliding():
		var collider = $Body/Head/VisionRayCast.get_collider()
		if collider.is_in_group("food"):
			$Body/Head/VisionRayCast.debug_shape_custom_color = Color(0, 255, 0)
			print("I see food")
			return true
		else:
			$Body/Head/VisionRayCast.debug_shape_custom_color = Color(174, 0, 0)
			print("I dont see food")
			return false
