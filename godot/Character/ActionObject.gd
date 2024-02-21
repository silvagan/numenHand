extends ShapeCast3D
func _physics_process(delta):
	for c in get_collision_count():
		var col = get_collider(c)
		if (col.is_in_group("food")):
			col.queue_free()
			if (get_parent().hunger < 50):
				get_parent().hunger += 50
			else: 
				get_parent().hunger = 100
