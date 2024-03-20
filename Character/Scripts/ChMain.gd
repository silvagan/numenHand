extends CharacterBody3D
#this is the MAIN character script
#MAIN

#character needs
var hunger = 100
var health = 100
var exaustion = 0

@onready var speed_stat = randf_range(.2,.5)
#character objective
var objective = "idle"

#load agent for navigation
@onready var nav_agent = $Navigation


#load all associated scripts
@onready var bar = $HealthBar3D
@onready var per = $Scripts/Perception
@onready var nav = $Scripts/Navigation
@onready var mem = $Scripts/Memory
@onready var itr = $Scripts/Interaction

func _ready():
	pass

func _physics_process(delta):
	
	#update objective, visuals and body rotation
	objective = update_objective()
	update_needs_visuals()
	nav.update_body_rotation()
	
	#act upon current objective
	match objective:
		"idle":
			nav.fall()
		"find food":
			nav.find_food()
		"eat":
			itr.eat()
		"find water":
			pass
		"go sleep":
			pass
		"gather resources":
			pass
		"explore":
			nav.explore()
		"urgent explore":
			nav.urgent_explore()

#called on timer timeout
func _on_tick_timeout():
	if(hunger > 0):
		hunger -= 1
	if(hunger <= 0):
		health -= 1
	if(health <= 0):
		queue_free()

#updates the objective based on criteria
func update_objective():
	if(objective == "eat" && hunger < 90):
		return "eat"
	if(objective == "urgent explore" && hunger < 50):
		return "urgent explore"
	elif(hunger < 50):
		return "find food"
	elif($Temp.get_time_left() > 0):
		return "idle"
	else:
		return "explore"

#updates needs visuals
func update_needs_visuals():
	bar.update(hunger, 100)



func _on_interaction_rebake_mesh(location):
	$"../NavigationRegion3D".rebakeMesh(location)
