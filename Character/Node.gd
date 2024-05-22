extends Node

var syncing_head_body = false
var right = false
var head_movement_speed = 0.5
var bonus = 1

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

#func look_at_target(target):
	#$Head.look_at(target, Vector3.UP)

@onready var vsray = $"../../Head/VisionRayCast"

func is_visible_from_view(target):
	vsray.look_at(target, Vector3.UP)
	vsray.force_raycast_update()
	
	if vsray.is_colliding():
		var collider = vsray.get_collider()
		if collider.is_in_group("food"):
			vsray.debug_shape_custom_color = Color(0, 255, 0)
			#print("I see food")
			return true
		else:
			vsray.debug_shape_custom_color = Color(174, 0, 0)
			#print("I dont see food")
			return false

func look_around():
	var hd = $"../../Head"
	var bd = $"../../Body"
	
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


func turn_head_left():
	var hd = $"../../Head"
	var bd = $"../../Body"
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

func sync_head_with_body():
	var hd = $"../../Head"
	var bd = $"../../Body"
	
	if(bonus > 1):
		sync_head_body(bonus)
		if(abs(hd.rotation_degrees.y-bd.rotation_degrees.y) < 10):
			bonus *= 0.5
		else:
			#print((abs($Head.rotation_degrees.y - $Body.rotation_degrees.y) / head_rotate_distance))
			#bonus *= pow((abs($Head.rotation_degrees.y - $Body.rotation_degrees.y)) / sqrt(head_rotate_distance), 1/3)
			bonus *= 0.97	
	else:
		sync_head_body(1)

func sync_head_body(bonus):	
	var hd = $"../../Head"
	var bd = $"../../Body"
	
	############################################################-45 -> -25
	rotate_head_vertical(-25)
		
	var turn_left = turn_head_left()
	if (round(hd.rotation_degrees.y) != round(bd.rotation_degrees.y)):
		if turn_left == true:
			#print("turn left")
			hd.rotation_degrees.y += 0.8 * bonus
			if(hd.rotation_degrees.y > bd.rotation_degrees.y):
				hd.rotation_degrees.y = bd.rotation_degrees.y
			#head_movement_speed = 0.5
		elif turn_left == false:
			#print("turn right")
			hd.rotation_degrees.y += -0.8 * bonus
			if(hd.rotation_degrees.y < bd.rotation_degrees.y):
				hd.rotation_degrees.y = bd.rotation_degrees.y
			#head_movement_speed = -0.5
		else:
			pass
			############################################################-45 -> -25
	elif (round(hd.rotation_degrees.x) == -25):
		#print("=====================================================================================")
		syncing_head_body = false

func rotate_head_vertical(angle):
	var hd = $"../Head"
	var bd = $"../Body"
	#print(rotation)
	print(get_parent().get_path())
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


func contains_type(all, type):
	for c in all:
		if(c.is_in_group(type) && is_visible_from_view(c.global_transform.origin)):
			return true

func get_first_obj(all, type):
	for c in all:
		if (c.is_in_group(type) && is_visible_from_view(c.global_transform.origin)):
			return c

func get_closest_obj(all, type):
	var hd = $"../../Head"
	var bd = $"../../Body"

	var m = get_first_obj(all, type)
	for c in all:
		if (c.is_in_group(type) && is_visible_from_view(c.global_transform.origin)):
			var c1 = hd.global_position.distance_to(c.global_position)
			var c2 = hd.global_position.distance_to(m.global_position)
			if (c1 < c2):
				m = c
	return m

