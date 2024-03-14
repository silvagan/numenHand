extends Node
#this is a script dedicated to the world INTERACTION of the character
#INTERACTION
@onready var ch = $"../.."
@onready var ir = $"../../InRange"
@onready var timer = $"../../InteractTimer"

@onready var per = $"../Perception"
var lookat = Vector3(0,0,0)

func eat():
	ch.nav.destination = ch.global_position
	if(lookat == Vector3(0,0,0)):
		lookat = ir.get_collider(0).global_position
		per.look_towards($"../../Head", lookat)
	else:
		per.look_towards($"../../Head", lookat)

	if(ir.get_collision_count()>0):
		if(timer.is_stopped()):
			timer.start()
		if(ch.hunger > 90):
			timer.stop()
			ch.objective = "explore"
	else:
		timer.stop()
		ch.objective = "find food"
		lookat = Vector3(0,0,0)


func _on_interact_timer_timeout():
	for c in ir.get_collision_count():
		var col = ir.get_collider(c)
		if (col.is_in_group("berry_bush") and col.pickable):
			#updates picked items data
			col.update()
			ch.mem.update()
			#if (get_parent().memory.has(col.global_position)):
				#get_parent().memory.erase(col.global_position)
			if (ch.hunger < 80):
				ch.hunger += 20
			else: 
				ch.hunger = 100
			ch.nav.destination = Vector3(0,0,0)
			ch.nav.navigating = false
