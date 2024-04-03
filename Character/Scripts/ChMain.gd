extends CharacterBody3D
#this is the MAIN character script
#MAIN

#character needs
var hunger = 100
var health = 100
var thirst = 100
var exaustion = 100

@onready var speed_stat = randf_range(0.8,1.2)

#character objective
var objective = "idle"

#load agent for navigation
@onready var nav_agent = $Navigation

#load all associated scripts
@onready var hebar = $Health
@onready var hubar = $Hunger
@onready var thbar = $Thirst
@onready var exbar = $Exaustion

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
	
	print(objective)
	
	#act upon current objective
	match objective:
		"idle":
			nav.fall()
		"find food":
			nav.find_food()
		"eat":
			itr.eat()
		"find water":
			nav.find_water()
		"drink":
			itr.drink()
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
		hunger -= 0.3
	if(thirst > 0):
		thirst -= 1
	if(hunger <= 0):
		health -= 1
	if(thirst <= 0):
		health -= 1
	if(exaustion > 0):
		exaustion -= 0.1
	if(health <= 0):
		queue_free()

#updates the objective based on criteria
func update_objective():
	if(objective == "eat"):
		return "eat"
	if(objective == "drink"):
		return "drink"
	if(objective == "urgent explore" && hunger < 50):
		return "urgent explore"
		
	if(objective == "urgent explore" && thirst < 50):
		return "urgent explore"
	elif(hunger < 50):
		return "find food"
	elif(thirst < 50 && objective != "find food"):
		return "find water"
	elif($Temp.get_time_left() > 0):
		return "idle"
	else:
		return "explore"

#updates needs visuals
func update_needs_visuals():
	hebar.update(health, 100)
	hubar.update(hunger, 100)
	thbar.update(thirst, 100)
	exbar.update(exaustion, 100)



func _on_interaction_rebake_mesh(location):
	$"../NavigationRegion3D".rebakeMesh(location)
