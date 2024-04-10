extends Node
#this is a script dedicated to the PERCEPTION of the character
#PERCEPTION

#boolean responsible for the sync of the head and body of the character
var syncing_head_body = false
var right = false #|subject to change|
#head movement speed and head movement speed bonus for a burst of movement at the start of target acquisition
var head_movement_speed = 0.5
var bonus = 1

#ready raycast for line of sight checking
@onready var vsray = $"../../Head/VisionRayCast"
#ready head and body reference
@onready var hd = $"../../Head"
@onready var bd = $"../../Body"

#look towards target location
func look_towards(node: Object, target, smooth_speed:= 0.1, return_only:= false):
	var smooth
	if smooth_speed == 0:
		smooth = false
	else:
		smooth = true
	if target is Object:
		target = target.global_transform.origin
	elif !target is Vector3:
		print("No target to look towards")
		get_tree().paused = true
		return
	var looker = Node3D.new()
	node.add_child(looker)
	looker.look_at(target, Vector3.UP)
	var finalRot = node.rotation_degrees + looker.rotation_degrees
	if return_only == true:
		return finalRot
	elif smooth == false:
		node.rotation_degrees = finalRot
	else:
		looker.look_at(target, Vector3.UP)
		finalRot = node.rotation_degrees + looker.rotation_degrees
		node.rotation_degrees = lerp(node.rotation_degrees, finalRot, smooth_speed)
	looker.queue_free()
	pass

#func look_at_target(target):
	#$Head.look_at(target, Vector3.UP)

#check if target is visible from view
func is_visible_from_view(target):
	
	vsray.look_at(target, Vector3.UP)
	vsray.force_raycast_update()
	
	if vsray.is_colliding():
		var collider = vsray.get_collider()
		if collider.is_in_group("berry_bush"):
			vsray.debug_shape_custom_color = Color(0, 255, 0)
			#print("I see food")
			return true
		elif collider.is_in_group("Campfire"):
			vsray.debug_shape_custom_color = Color(255,179,0)
			return true
		elif collider.is_in_group("water"):
			vsray.debug_shape_custom_color = Color(21,110,212)
			return true
		else:
			vsray.debug_shape_custom_color = Color(174, 0, 0)
			#print("I dont see food")
			return false

#head movement pattern for scanning the surroundings
func look_around():
	
	var v1 = hd.rotation_degrees.y
	var v2 = bd.rotation_degrees.y
	var angle = int(abs(v1-v2)) % 360
	############################################################ 90 -> 60
	if(angle > 60 && right == false):
		#print(angle)
		head_movement_speed *= -1
		right = true
	############################################################ 90 -> 60
	if(angle < 60):
		right = false
	hd.rotation_degrees.y += head_movement_speed	
		
	if(hd.rotation_degrees.x < -15):
		hd.rotation_degrees.x += 0.5

#indicated whether the head should be turned left or right to minimise head rotation |subject to change|
func turn_head_left():
	var diff = abs(hd.rotation_degrees.y - bd.rotation_degrees.y)
	#print($Head.rotation_degrees.y, " - ", $Body.rotation_degrees.y)
		
	if (diff > 180):
		if (abs(hd.rotation_degrees.y) > abs(bd.rotation_degrees.y)):
			if(hd.rotation_degrees.y > 0):
				hd.rotation_degrees.y -= 360
			else:
				hd.rotation_degrees.y += 360
		else:
			if(bd.rotation_degrees.y > 0):
				bd.rotation_degrees.y -= 360
			else:
				bd.rotation_degrees.y += 360
	
	#print($Head.rotation_degrees.y, " - ", $Body.rotation_degrees.y)
	
	if (hd.rotation_degrees.y > bd.rotation_degrees.y):
		return false
	else:
		return true

#head movement pattern for syncing head with body |subject to change|
func sync_head_with_body():
	
	if(bonus > 1):
		sync_head_body(bonus)
		if(abs(hd.rotation_degrees.y-bd.rotation_degrees.y) < 10):
			bonus *= 0.5
		else:
			bonus *= 0.97	
	else:
		sync_head_body(1)

#gradually change head rotation to match body rotation
func sync_head_body(bonus):	
	
	rotate_head_vertical(-25)
	
	var turn_left = turn_head_left()
	if (round(hd.rotation_degrees.y) != round(bd.rotation_degrees.y)):
		if turn_left == true:
			#print("turn left")
			hd.rotation_degrees.y += 0.8 * bonus
			if(hd.rotation_degrees.y > bd.rotation_degrees.y):
				hd.rotation_degrees.y = bd.rotation_degrees.y
		elif turn_left == false:
			#print("turn right")
			hd.rotation_degrees.y += -0.8 * bonus
			if(hd.rotation_degrees.y < bd.rotation_degrees.y):
				hd.rotation_degrees.y = bd.rotation_degrees.y
		else:
			pass
	elif (round(hd.rotation_degrees.x) == -25):
		syncing_head_body = false

#responsible for vertical head allignment to angle
func rotate_head_vertical(angle):
	
	#print(rotation)
	if (hd.rotation_degrees.x > angle):
		hd.rotation_degrees.x -= 1
		if (hd.rotation_degrees.x < angle):
			hd.rotation_degrees.x = angle
	elif (hd.rotation_degrees.x < angle):
		hd.rotation_degrees.x += 1
		if (hd.rotation_degrees.x > angle):
			hd.rotation_degrees.x = angle
	else:
		pass

#check if contains type
func contains_type(all, type):
	for c in all:
		if(c.is_in_group(type) && is_visible_from_view(c.global_transform.origin)):
			return true

#get first object of type
func get_first_obj(all, type):
	for c in all:
		if (c.is_in_group(type) && is_visible_from_view(c.global_transform.origin)):
			return c

#get closest object of type
func get_closest_obj(all, type):

	var m = get_first_obj(all, type)
	for c in all:
		if (c.is_in_group(type) && is_visible_from_view(c.global_transform.origin)):
			var c1 = hd.global_position.distance_to(c.global_position)
			var c2 = hd.global_position.distance_to(m.global_position)
			if (c1 < c2):
				m = c
	return m

