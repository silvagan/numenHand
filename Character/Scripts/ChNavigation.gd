#class_name Navigation
extends Node
#this is a script dedicated to the NAVIGATION of the character
#NAVIGATION

#destination is null if Vector(0,0,0)
var destination = Vector3(0,0,0)
#character state for minimisation of 'set destination' functions
var navigating = false
#character movement speed

@onready var seed = $"../..".seed
@onready var anim_tree = $AnimationTree
@onready var model = $"../../Rig"



var randNumGen = RandomNumberGenerator.new()
#ready NPCharacter for use in calls
@onready var ch = $"../.."
#ready perception and memory scripts for use in furher functions
@onready var per = $"../Perception"
@onready var mem = $"../Memory"
#ready arrow for debugging
@onready var dbarrow = preload("res://Debug_arrow.tscn")

#character movement speed
#var movement_speed = 5.0 * ch.speed
#var movement_speed = 5.0
func _ready():
	randNumGen.seed = seed
#responsible for body movement and head rotation
func go_to(location, head_movement_mode):
	
	update_target_location(location)
	var current_location = ch.global_transform.origin
	var next_position = ch.nav_agent.get_next_path_position()
	var new_velocity = (next_position - current_location).normalized() * ch.movement_speed
	ch.velocity = new_velocity

	
	var vl = ch.velocity * model.transform.basis
	ch.anim_tree.set("parameters/IdleRun/blend_position", Vector2(vl.x, -vl.z) / ch.movement_speed)
	

	ch.move_and_slide()
		
	match head_movement_mode:
		"default":
			if (per.syncing_head_body == true):
				per.sync_head_with_body()
			else:
				per.look_around()
		"destination":
			per.look_towards($"../../Head", ch.nav_agent.target_position)
			
func go_near(location, head_movement_mode):
	update_target_location(location)
	var current_location = ch.global_transform.origin
	var new_velocity = (ch.nav_agent.get_next_path_position() - ch.global_transform.origin).normalized() * ch.movement_speed
	ch.velocity = new_velocity
	ch.move_and_slide()
		
	match head_movement_mode:
		"default":
			if (per.syncing_head_body == true):
				per.sync_head_with_body()
			else:
				per.look_around()
		"destination":
			per.look_towards($"../../Head", ch.nav_agent.target_position)
			
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
func get_random_location(distance):
	#movement_speed = speed * ch.speed_stat
	var x = ch.global_transform.origin.x
	var z = ch.global_transform.origin.z
	
	x += randNumGen.randf_range(-distance,distance)
	z += randNumGen.randf_range(-distance,distance)
	
	var y = ch.global_transform.origin.y
	
	return Vector3(x, y, z)

#behaviour for roaming and updating memory
func explore():
	var visible_ob = $"../../Head/Vision".get_overlapping_bodies()

	if(per.contains_type(visible_ob, "Campfire")):
		if !mem.has_type("Campfire"):
			if(mem.memory.size() == mem.size):
				mem.memory.erase(mem.get_farthest_memory_item("berry_bush"))
				mem.memory.append(per.get_closest_obj(visible_ob,"Campfire"))
				print("added home to memory")
			else:			
				mem.memory.append(per.get_closest_obj(visible_ob,"Campfire"))
				print("added home to memory")
			
	#finds food and checks it with memory to replace it ir not
	if(per.contains_type(visible_ob, "berry_bush")):
		var food_in_vision = per.get_closest_obj(visible_ob, "berry_bush")
		if(mem.memory.size() == mem.size):
			var memory_food = ch.position.distance_to(mem.get_farthest_memory_item("berry_bush").position)
			var seen_food = ch.position.distance_to(food_in_vision.position)
			if (memory_food > seen_food): 
				mem.memory.erase(mem.get_farthest_memory_item("berry_bush"))
				mem.memory.append(food_in_vision)
				print("swaped memory item")
		else:
			if !mem.memory.has(food_in_vision):
				mem.memory.append(food_in_vision)
				print("added new food to memory")
	
	if(per.contains_type(visible_ob, "water")):
		var water_in_vision = per.get_closest_obj(visible_ob, "water")
		if (!mem.has_type("water")):			
			if(mem.memory.size() == mem.size):				
				mem.memory.erase(mem.get_farthest_memory_item("berry_bush"))
				mem.memory.append(water_in_vision)
				print("added new water source to memory")
			else:
				mem.memory.append(water_in_vision)
				print("added new water source to memory")
		else:
			if !mem.memory.has(water_in_vision):
				var memory_water = ch.position.distance_to(mem.get_closest_memory_item("water").position)
				var seen_water = ch.position.distance_to(water_in_vision.position)
				if memory_water > seen_water:
					mem.memory.erase(mem.get_closest_memory_item("water"))
					mem.memory.append(water_in_vision)
					print("swaped water source")
					
	if(per.contains_type(visible_ob, "tree")):
		var tree_in_vision = per.get_closest_obj(visible_ob, "tree")
		destination = tree_in_vision.position
		ch.objective = "cut tree"
		
		
	if(destination != Vector3(0,0,0)):
		go_to(destination, "default")
	else:
		destination = get_random_location(30) # (5,50)
		per.syncing_head_body = true
		per.bonus = 5
		go_to(destination, "default")

#behaviour for anything related to getting food
func find_food():
	if(per.contains_type($"../../InRange".get_overlapping_bodies(), "berry_bush")):
		ch.objective = "eat"
	if(navigating):
		go_to(destination, "destination")
	elif (mem.has_type("berry_bush")):
		go_to(mem.get_closest_memory_item("berry_bush").position,"destination")
	else:
		var visible_ob = $"../../Head/Vision".get_overlapping_bodies()
		if(per.contains_type(visible_ob, "berry_bush")):
			destination = per.get_closest_obj(visible_ob, "berry_bush").position
			go_to(destination, "destination")
			navigating = true
		else:
			ch.objective = "urgent explore food"
			
			
func find_water():
	if(per.contains_type($"../../InRange".get_overlapping_bodies(), "water")):
		ch.objective = "drink"
	if(navigating):
		go_to(destination, "destination")
	elif(mem.has_type("water")):
		go_to(mem.get_closest_memory_item("water").get_parent().position,"destination")
	else:
		var visible_ob = $"../../Head/Vision".get_overlapping_bodies()
		if(per.contains_type(visible_ob, "water")):
			destination = per.get_closest_obj(visible_ob, "water").get_parent().position
			go_to(destination, "destination")
			navigating = true
		else:
			ch.objective = "urgent explore water"
			
			
func go_rest():	
	if(per.contains_type($"../../InRange".get_overlapping_bodies(), "Campfire")):
		ch.objective = "rest"
	if(navigating):
		go_to(destination, "destination")
	elif(mem.has_type("Campfire")):
		go_to(mem.home_location(),"destination")
	else:
		var visible_ob = $"../../Head/Vision".get_overlapping_bodies()
		if(per.contains_type(visible_ob, "Campfire")):
			destination = per.get_closest_obj(visible_ob, "Campfire").position
			go_to(destination, "destination")
			navigating = true
		else:
			#ch.objective = "urgent explore"
			pass
		

#behaviour that is accessed when no food is in the area // similar to explore
func urgent_explore_food():
	var visible_ob = $"../../Head/Vision".get_overlapping_bodies()
	
	if(per.contains_type(visible_ob, "berry_bush") && ch.hunger < 50):
		ch.objective = "find food"
		#movement_speed = 9 * ch.speed_stat
		destination = Vector3(0,0,0)
		return
	if (destination != Vector3(0,0,0)):
		go_to(destination, "default")
	else:
		destination = get_random_location(15) # (5,10)
		per.syncing_head_body = true
		per.bonus = 5
		go_to(destination, "default")
		
#behaviour that is accessed when no food is in the area // similar to explore
func urgent_explore_water():
	var visible_ob = $"../../Head/Vision".get_overlapping_bodies()
	
	if(per.contains_type(visible_ob, "water")):
		ch.objective = "find water"
		#movement_speed = 9 * ch.speed_stat
		destination = Vector3(0,0,0)
		return
	if (destination != Vector3(0,0,0)):
		go_to(destination, "default")
	else:
		destination = get_random_location(15) # (5,10)
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
	ch.nav_agent.set_target_position(target_location)
	
#is called on targetlocation reached
func _on_navigation_navigation_finished():
	destination = Vector3(0,0,0)
	navigating = false
	
#updates body rotation according to momentum
func update_body_rotation():
	var lookdir = atan2(-ch.velocity.x, -ch.velocity.z)
	$"../../Body".rotation.y = lookdir
	#$"../../Body"
	$"../../Rig/Skeleton3D".rotation.y = lookdir

func cut_tree():
	if(per.contains_type($"../../InRange".get_overlapping_bodies(), "tree")):
		ch.objective = "cut"
	if(navigating):
		go_to(destination, "destination")
	else:
		var visible_ob = $"../../Head/Vision".get_overlapping_bodies()
		if(per.contains_type(visible_ob, "tree")):
			destination = per.get_closest_obj(visible_ob, "tree").position
			go_to(destination, "destination")
			navigating = true
		else:
			pass
