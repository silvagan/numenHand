extends ShapeCast3D

#func _physics_process(delta):
	#if (get_parent().has_target == true):
		#pass
	#if (get_collision_count() > 0):
		#if (contains_ball() == true && get_parent().hunger <= 70):
			#get_closest()
			#get_parent().has_target = true
		#pass
	#pass
	#
#func contains_ball():
	#for c in get_collision_count():
		#if(get_collider(c).is_in_group("food")):
			#return true
#
#func get_first_ball():
	#for c in get_collision_count():
		#var col = get_collider(c)
		#if (col.is_in_group("food")):
			#return col
#
#func get_closest():
	#var m = get_first_ball()
	#for c in get_collision_count():
		#var col = get_collider(c)
		#if (col.is_in_group("food")):
			#var c1 = diff(col)
			#var c2 = diff(m)
			#if (c1 < c2):
				#m = col
	#get_parent().update_target_location(m.global_position)
	#get_parent().SPEED = 5.0
#
#func get_closest_in_range(range):
	#var food = get_tree().get_nodes_in_group("food")
	#pass
#
#func diff(ob):
	#var x1 = self.global_position.x
	#var y1 = self.global_position.y
	#var z1 = self.global_position.z
	#var x2 = ob.global_position.x
	#var y2 = ob.global_position.y
	#var z2 = ob.global_position.z
	#var s1 = abs(x1-x2)
	#var s2 = abs(y1-y2)
	#var s3 = abs(z1-z2)
	#return s1 + s2 + s3
	#
