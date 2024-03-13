extends CharacterBody3D
#this is the MAIN character script
#MAIN

#character needs
var hunger = 100
var health = 100
var exaustion = 0

#character timer and objective
var timer = 0
var objective = "idle"

#load agent for navigation
@onready var nav_agent = $Navigation


#load all associated scripts
@onready var bar = $HealthBar3D
@onready var per = $Scripts/Perception
@onready var nav = $Scripts/Navigation
@onready var mem = $Scripts/Memory
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
	timer += 1
	if(hunger > 0):
		hunger -= 1
	if(hunger <= 0):
		health -= 1
	if(health <= 0):
		queue_free()

#updates the objective based on criteria
func update_objective():
	if(objective == "urgent explore" && hunger < 90):
		return "urgent explore"
	if(hunger < 90):
		return "find food"
	elif(timer < 5):
		return "idle"
	else:
		return "explore"

#updates needs visuals
func update_needs_visuals():
	bar.update(hunger, 100)

