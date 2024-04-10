extends Node
#this is a script dedicated to the world INTERACTION of the character
#INTERACTION
@onready var ch = $"../.."
@onready var ir = $"../../InRange"
@onready var timer = $"../../InteractTimer"

@onready var per = $"../Perception"
var lookat = Vector3(0,0,0)

signal rebakeMesh(location)

func eat():
	ch.nav.destination = ch.global_position
	if(lookat == Vector3(0,0,0)):
		lookat = per.get_first_obj(ir.get_overlapping_bodies(), "berry_bush").position
		per.look_towards($"../../Head", lookat)
	else:
		per.look_towards($"../../Head", lookat)
#<<<<<<< HEAD

	#print(ir.get_overlapping_bodies().size())
	#print($"../../InRange".get_overlapping_bodies().size())
#=======
#>>>>>>> 5e299e4c9f148e14235c96a01d20c3e74099b166
		 	
	if(per.contains_type(ir.get_overlapping_bodies(), "berry_bush")):
		if(timer.is_stopped()):
			timer.start()
		if(ch.hunger > 90):
			timer.stop()
			ch.objective = "explore"
	else:
		timer.stop()
		ch.objective = "find food"
		lookat = Vector3(0,0,0)

func drink():
	ch.nav.destination = ch.global_position
	if(lookat == Vector3(0,0,0)):
		lookat = per.get_first_obj(ir.get_overlapping_bodies(), "water").position
		per.look_towards($"../../Head", lookat)
	else:
		per.look_towards($"../../Head", lookat)
#<<<<<<< HEAD

	#print(ir.get_overlapping_bodies().size())
	#print($"../../InRange".get_overlapping_bodies().size())
#=======
#>>>>>>> 5e299e4c9f148e14235c96a01d20c3e74099b166
		 	
	if(per.contains_type(ir.get_overlapping_bodies(), "water")):
		if(timer.is_stopped()):
			timer.start()
		if(ch.thirst > 90):
			timer.stop()
			ch.objective = "explore"
	else:
		timer.stop()
		ch.objective = "find water"
		lookat = Vector3(0,0,0)
		
func rest():
	ch.nav.destination = ch.global_position
	if(lookat == Vector3(0,0,0)):
		lookat = per.get_first_obj(ir.get_overlapping_bodies(), "Campfire").position
		per.look_towards($"../../Head", lookat)
	else:
		per.look_towards($"../../Head", lookat)
#<<<<<<< HEAD

	#print(ir.get_overlapping_bodies().size())
	#print($"../../InRange".get_overlapping_bodies().size())
#=======
#>>>>>>> 5e299e4c9f148e14235c96a01d20c3e74099b166
		 	
	if(per.contains_type(ir.get_overlapping_bodies(), "Campfire")):
		if(timer.is_stopped()):
			timer.start()
		if(ch.exhaustion > 90):
			timer.stop()
			ch.objective = "explore"
	else:
		timer.stop()
		ch.objective = "go_rest"
		lookat = Vector3(0,0,0)

func _on_interact_timer_timeout():
	for c in ir.get_overlapping_bodies():
		if (c.is_in_group("berry_bush")):
			#updates picked items data
			if(c.update()):
				await get_tree().create_timer(0.01).timeout
				ch.mem.update()
			
			if (ch.hunger < 80):
				ch.hunger += 20
			else: 
				ch.hunger = 100
			ch.nav.destination = Vector3(0,0,0)
			ch.nav.navigating = false
		elif (c.is_in_group("water")):
			
			if (ch.thirst < 80):
				ch.thirst += 30
			else: 
				ch.thirst = 100
			ch.nav.destination = Vector3(0,0,0)
			ch.nav.navigating = false
		elif (c.is_in_group("Campfire")):
			if(ch.exhaustion < 80):
				ch.exhaustion += 20
			else:
				ch.exhaustion = 100
			ch.nav.destination = Vector3(0,0,0)
			ch.nav.navigating = false
