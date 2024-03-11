extends Node
#this is a script dedicated to the NAVIGATION of the character
#NAVIGATION

#destination is null if Vector(0,0,0)
var destination = Vector3(0,0,0)
#character state for minimisation of 'set destination' functions
var navigating = false
#character movement speed
var movement_speed = 5.0

#character place for easier acces and cleaner code :)
@onready var char = $"../.."
#ready perception and memory scripts for use in furher functions
@onready var per = $"../Perception"
@onready var mem = $"../Memory"
#ready arrow for debugging
@onready var dbarrow = preload("res://Debug_arrow.tscn")

#responsible for body movement and head rotation
func go_to(location, head_movement_mode):
	update_target_location(location)
	var current_location = char.global_transform.origin
	var new_velocity = (char.nav_agent.get_next_path_position() - char.global_transform.origin).normalized() * movement_speed
	char.velocity = new_velocity
	char.move_and_slide()
		
	match head_movement_mode:
		"default":
			if (per.syncing_head_body == true):
				per.sync_head_with_body()
			else:
				per.look_around()
		"destination":
			per.look_towards($"../../Head", char.nav_agent.target_position)
			
#func get_point_on_map(target_point: Vector3, min_dist_from_edge: float) -> Vector3:
	#var map := $".".get_world_3d().navigation_map
	#var closest_point := NavigationServer3D.map_get_closest_point(map, target_point)
	#var delta := closest_point - target_point
	#var is_on_map = delta.is_zero_approx()  # Answer to original question!
	#if not is_on_map and min_dist_from_edge > 0:
		## Wasn't on the map, so push in from edge. If you have thin sections on
		## your navmesh, this could push it back off the navmesh!
		#delta = delta.normalized()
		#closest_point += delta * min_dist_from_edge
	#return closest_point
	
#gets random location based on distance from current object
func get_random_location(speed, distance):
	movement_speed = speed
	var x = char.global_transform.origin.x
	var z = char.global_transform.origin.z
	
	x += randf_range(-distance, distance)
	z += randf_range(-distance, distance)
	var y = char.global_transform.origin.y
	
	return Vector3(x, y, z)

#behaviour for roaming and updating memory
func explore():
	var visible_ob = $"../../Head/Vision".get_overlapping_bodies()
	#finds food and checks it with memory to replace it ir not
	if(per.contains_type(visible_ob, "food")):
		var food_in_vision = per.get_closest_obj(visible_ob, "food")
		if(mem.memory.size() > 0 and is_instance_valid(mem.memory[0])):
			var memory_food = char.position.distance_to(mem.memory[0].position)
			var seen_food = char.position.distance_to(food_in_vision.position)
			if (memory_food > seen_food and mem.memory[0] != food_in_vision): 
				mem.memory.clear()
				mem.memory.append(food_in_vision)
				print("swaped memory item", food_in_vision.position)
				var debug = dbarrow.instantiate()
				debug.position.x = food_in_vision.position.x
				debug.position.z = food_in_vision.position.z
				debug.position.y = food_in_vision.position.y
				$"..".add_child(debug)
		else:
			mem.memory.clear()
			mem.memory.append(food_in_vision)
			print("added new to memory", mem.memory[0].position)
			var debug = dbarrow.instantiate()
			debug.position.x = food_in_vision.position.x
			debug.position.z = food_in_vision.position.z
			debug.position.y = food_in_vision.position.y
			$"..".add_child(debug)
	if(destination != Vector3(0,0,0)):
		go_to(destination, "default")
	else:
		destination = get_random_location(5, 50)
		per.syncing_head_body = true
		per.bonus = 5
		go_to(destination, "default")

#behaviour for anything related to getting food
func find_food():
	if(navigating):
		go_to(destination, "destination")
	elif (mem.memory.size() > 0):
		if(!is_instance_valid(mem.memory[0])):
			mem.memory.clear()
			return
		print(mem.memory.size())
		var debug = dbarrow.instantiate()
		debug.position = mem.memory[0].position
		$"..".add_child(debug)
		print("going to memory",mem.memory[0].position)
		go_to(mem.memory[0].position,"destination")
	else:
		var visible_ob = $"../../Head/Vision".get_overlapping_bodies()
		if(per.contains_type(visible_ob, "food")):
			destination = per.get_closest_obj(visible_ob, "food").position
			go_to(destination, "destination")
			navigating = true
		else:
			char.objective = "urgent explore"
			
#behaviour that is accessed when no food is in the area // similar to explore
func urgent_explore():
	var visible_ob = $"../../Head/Vision".get_overlapping_bodies()
	if(per.contains_type(visible_ob, "food")):
		char.objective = "find food"
		movement_speed = 9
		destination = Vector3(0,0,0)
		return
	if (destination != Vector3(0,0,0)):
		go_to(destination, "default")
	else:
		destination = get_random_location(5, 10)
		per.syncing_head_body = true
		per.bonus = 5
		go_to(destination, "default")
		
#behaviour that is responsible for the objects navigaion to the ground
func fall():
	if(navigating):
		go_to(destination, "destination")
	else:
		destination = Vector3(0,0,0)
		go_to(destination, "destination")
		navigating = true
	
#updates the nav agent with a new target location
func update_target_location(target_location):
	char.nav_agent.set_target_position(target_location)
	
#is called on targetlocation reached
func _on_navigation_navigation_finished():
	destination = Vector3(0,0,0)
	navigating = false
	
#updates body rotation according to momentum
func update_body_rotation():
	var lookdir = atan2(-char.velocity.x, -char.velocity.z)
	$"../../Body".rotation.y = lookdir
