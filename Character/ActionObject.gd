extends ShapeCast3D

func _physics_process(delta):
	for c in get_collision_count():
		var col = get_collider(c)
		if (col.is_in_group("berry_bush") and col.pickable):
			#updates picked items data
			col.update()
			$"../Scripts/Memory".update()
			#if (get_parent().memory.has(col.global_position)):
				#get_parent().memory.erase(col.global_position)
			if (get_parent().hunger < 50):
				get_parent().hunger += 50
			else: 
				get_parent().hunger = 100
			$"..".nav.destination = Vector3(0,0,0)
			$"..".nav.navigating = false
