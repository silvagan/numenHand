extends CharacterBody3D

@onready var nav_agent = $Navigation

var movement_speed = 5.0
var destination = Vector3(0,0,0)
var navigating = false
var syncing_head_body = false
var hunger = 100
var health = 100
var exaustion = 0
var head_movement_speed = 0.5
var bonus = 1
var memory = []
var objective = "idle"
var right = false

@onready var bar = $HealthBar3D

func _ready():
	#update_target_location(get_random_near_location())
	#has_target = true
	pass



func _physics_process(delta):
	
	objective = update_objective()
	update_needs_visuals()
	
	var lookdir = atan2(-velocity.x, -velocity.z)
	$Body.rotation.y = lookdir
	
	match objective:
		"idle":
			pass
		"find food":
			if(navigating):
				go_to(destination, "destination")
			else:
				var visible_ob = $Head/VisionCones.get_overlapping_bodies()
				if(contains_food(visible_ob)):
					destination = get_food_closest(visible_ob)
					go_to(destination, "destination")
					navigating = true
				
				#elif(memory.size() > 0):
					#destination = get_food_closest_memory()
					#if (is_visible_from_view(destination)):
						#go_to(destination, "destination")
						#navigating = true
					#else:
						#destination = Vector3(0,0,0)
						#memory.erase(get_food_closest_memory())
						#return
				else:
					objective = "urgent explore"
		"find water":
			pass
		"go sleep":
			pass
		"gather resources":
			pass
		"explore":
			var visible_ob = $Head/VisionCones.get_overlapping_bodies()
			#if(contains_food(visible_ob)):
				#memory.append(get_food_closest(visible_ob))
			if(destination != Vector3(0,0,0)):
				go_to(destination, "default")
			else:
				destination = get_random_location(5, 50)
				print(get_point_on_map(destination, 1).distance_to(destination))
				if(get_point_on_map(destination, 1).distance_to(destination) < 10):
					syncing_head_body = true
					bonus = 5
					go_to(destination, "default")
		"urgent explore":
			var visible_ob = $Head/VisionCones.get_overlapping_bodies()
			if(contains_food(visible_ob)):
				objective = "find food"
				movement_speed = 9
				destination = Vector3(0,0,0)
				return
			if (destination != Vector3(0,0,0)):
				go_to(destination, "default")
			else:
				destination = get_random_location(5, 10)
				print(get_point_on_map(destination, 1).distance_to(destination))
				if(get_point_on_map(destination, 1).distance_to(destination) < 10):
					syncing_head_body = true
					bonus = 5
					go_to(destination, "default")
	
	
func go_to(location, head_movement_mode):
	update_target_location(location)
	var current_location = global_transform.origin
	var new_velocity = (nav_agent.get_next_path_position() - global_transform.origin).normalized() * movement_speed
	velocity = new_velocity
	move_and_slide()
		
	match head_movement_mode:
		"default":
			if (syncing_head_body == true):
				sync_head_with_body()
			else:
				look_around()
		"destination":
			look_towards($Head, nav_agent.target_position)
			#look_at_target(nav_agent.target_position)


func update_objective():
	if(objective == "urgent explore" && hunger < 70):
		return "urgent explore"
	if(hunger < 70):
		return "find food"
	else:
		return "explore"


func get_point_on_map(target_point: Vector3, min_dist_from_edge: float) -> Vector3:
	var map := get_world_3d().navigation_map
	var closest_point := NavigationServer3D.map_get_closest_point(map, target_point)
	var delta := closest_point - target_point
	var is_on_map = delta.is_zero_approx()  # Answer to original question!
	if not is_on_map and min_dist_from_edge > 0:
		# Wasn't on the map, so push in from edge. If you have thin sections on
		# your navmesh, this could push it back off the navmesh!
		delta = delta.normalized()
		closest_point += delta * min_dist_from_edge
	return closest_point

func get_random_location(speed, distance):
	movement_speed = speed
	var x = global_transform.origin.x
	var z = global_transform.origin.z
	
	x += randf_range(-distance, distance)
	z += randf_range(-distance, distance)
	var y = global_transform.origin.y
	
	return Vector3(x, y, z)

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func _on_navigation_navigation_finished():
	destination = Vector3(0,0,0)
	navigating = false

func _on_tick_timeout():
	if(hunger > 0):
		hunger -= 1
	if(hunger <= 0):
		health -= 1
	if(health <= 0):
		queue_free()
		

#func _on_vision_timer_timeout():
	#if (has_target == true):
		#pass
	#var overlaps = $Head/VisionCones.get_overlapping_bodies()
	##print(str(overlaps.size()) + " objects in view")
	#if overlaps.size() > 0:
		#if (contains_food(overlaps) == true):
			#if (hunger <= 70):
				#update_target_location(get_closest(overlaps))
				#has_target = true
				#has_destination = true
				#SPEED = 5.0
			#elif (!memory.has(get_closest(overlaps))):
				#memory.append(get_closest(overlaps))
		#pass
	#pass

func contains_food(all):
	for c in all:
		if(c.is_in_group("food") && is_visible_from_view(c.global_transform.origin)):
			return true

func get_first_food(all):
	for c in all:
		if (c.is_in_group("food") && is_visible_from_view(c.global_transform.origin)):
			return c

func get_food_closest(all):
	var m = get_first_food(all)
	for c in all:
		if (c.is_in_group("food") && is_visible_from_view(c.global_transform.origin)):
			var c1 = diff(c.global_position)
			var c2 = diff(m.global_position)
			if (c1 < c2):
				m = c
	return m.global_position

func get_food_closest_memory():
	var m = memory[0]
	for c in memory:
		var c1 = diff(c)
		var c2 = diff(m)
		if (c1 < c2):
			m = c
	movement_speed = 5.0
	return m

func diff(ob):
	var x1 = self.global_position.x
	var y1 = self.global_position.y
	var z1 = self.global_position.z
	var x2 = ob.x
	var y2 = ob.y
	var z2 = ob.z
	var s = sqrt(pow(x2 - x1, 2)+pow(y2 - y1, 2)+pow(z2 - z1, 2))
	return s

func look_towards(node: Object, vector, smooth_speed:= 0.1, return_only:= false):
	var smooth
	if smooth_speed == 0:
		smooth = false
	else:
		smooth = true
	if vector is Object:
		vector = vector.global_transform.origin
	elif !vector is Vector3:
		print("No target to look towards")
		get_tree().paused = true
		return
	var looker = Node3D.new()
	node.add_child(looker)
	looker.look_at(vector, Vector3.UP)
	var finalRot = node.rotation_degrees + looker.rotation_degrees
	if return_only == true:
		return finalRot
	elif smooth == false:
		node.rotation_degrees = finalRot
	else:
		looker.look_at(vector, Vector3.UP)
		finalRot = node.rotation_degrees + looker.rotation_degrees
		node.rotation_degrees = lerp(node.rotation_degrees, finalRot, smooth_speed)
	looker.queue_free()
	pass


func look_at_target(target):
	#print($Head.rotation)
	#print($Head.position, " ", target)
	#var direction = $Head.position.direction_to(target)
	#print(direction)
	#$Head.rotation = lerp($Head.rotation, direction, 0.2)
	#print($Head.rotation)
	#print("-")
	#var direction = (target - $Head.position).normalized()
	#var right = up_direction.cross(direction).normalized()
	#var up = direction.cross(right)
	#$Head.transform.basis = Basis(right, up, direction)

	$Head.look_at(target, Vector3.UP)

func is_visible_from_view(target):
	$Head/VisionRayCast.look_at(target, Vector3.UP)
	$Head/VisionRayCast.force_raycast_update()
	
	if $Head/VisionRayCast.is_colliding():
		var collider = $Head/VisionRayCast.get_collider()
		if collider.is_in_group("food"):
			$Head/VisionRayCast.debug_shape_custom_color = Color(0, 255, 0)
			#print("I see food")
			return true
		else:
			$Head/VisionRayCast.debug_shape_custom_color = Color(174, 0, 0)
			#print("I dont see food")
			return false

func look_around():
	var angle = int(abs($Head.rotation_degrees.y-$Body.rotation_degrees.y)) % 360
	############################################################ 90 -> 60
	if(angle > 60 && right == false):
		print(angle)
		head_movement_speed *= -1
		right = true
	############################################################ 90 -> 60
	if(angle < 60):
		right = false
	$Head.rotation_degrees.y += head_movement_speed	
		
	if($Head.rotation_degrees.x < -15):
		$Head.rotation_degrees.x += 0.5

func turn_head_left():

	var diff = abs($Head.rotation_degrees.y - $Body.rotation_degrees.y)
	print($Head.rotation_degrees.y, " - ", $Body.rotation_degrees.y)
		
	if (diff > 180):
		if (abs($Head.rotation_degrees.y) > abs($Body.rotation_degrees.y)):
			if($Head.rotation_degrees.y > 0):
				$Head.rotation_degrees.y -= 360
			else:
				$Head.rotation_degrees.y += 360
		else:
			if($Body.rotation_degrees.y > 0):
				$Body.rotation_degrees.y -= 360
			else:
				$Body.rotation_degrees.y += 360
	
	print($Head.rotation_degrees.y, " - ", $Body.rotation_degrees.y)
	
	if ($Head.rotation_degrees.y > $Body.rotation_degrees.y):
		return false
	else:
		return true

func sync_head_with_body():
	if(bonus > 1):
		sync_head_body(bonus)
		if(abs($Head.rotation_degrees.y-$Body.rotation_degrees.y) < 10):
			bonus *= 0.5
		else:
			#print((abs($Head.rotation_degrees.y - $Body.rotation_degrees.y) / head_rotate_distance))
			#bonus *= pow((abs($Head.rotation_degrees.y - $Body.rotation_degrees.y)) / sqrt(head_rotate_distance), 1/3)
			bonus *= 0.97	
	else:
		sync_head_body(1)

func sync_head_body(bonus):	
	############################################################-45 -> -25
	rotate_head_vertical(-25)
		
	var turn_left = turn_head_left()
	if (round($Head.rotation_degrees.y) != round($Body.rotation_degrees.y)):
		if turn_left == true:
			print("turn left")
			$Head.rotation_degrees.y += 0.8 * bonus
			if($Head.rotation_degrees.y > $Body.rotation_degrees.y):
				$Head.rotation_degrees.y = $Body.rotation_degrees.y
			#head_movement_speed = 0.5
		elif turn_left == false:
			print("turn right")
			$Head.rotation_degrees.y += -0.8 * bonus
			if($Head.rotation_degrees.y < $Body.rotation_degrees.y):
				$Head.rotation_degrees.y = $Body.rotation_degrees.y
			#head_movement_speed = -0.5
		else:
			pass
			############################################################-45 -> -25
	elif (round($Head.rotation_degrees.x) == -25):
		print("=====================================================================================")
		syncing_head_body = false

func rotate_head_vertical(angle):
	if ($Head.rotation_degrees.x > angle):
		$Head.rotation_degrees.x -= 1
		if ($Head.rotation_degrees.x < angle):
			$Head.rotation_degrees.x = angle
	elif ($Head.rotation_degrees.x < angle):
		$Head.rotation_degrees.x += 1
		if ($Head.rotation_degrees.x > angle):
			$Head.rotation_degrees.x = angle
	else:
		pass

func update_needs_visuals():
	bar.update(hunger, 100)
