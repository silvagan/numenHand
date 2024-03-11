extends CharacterBody3D


@onready var nav_agent = $Navigation
@onready var debug_arrow = preload("res://Debug_arrow.tscn")

var hunger = 100
var health = 100
var exaustion = 0

var timer = 0

var objective = "idle"


@onready var bar = $HealthBar3D
@onready var per = $Scripts/Node
@onready var nav = $Scripts/Navigation
@onready var mem = $Scripts/Memory

func _ready():
	pass


func _physics_process(delta):
	
	objective = update_objective()
	update_needs_visuals()
	nav.update_body_rotation()
	
	print(objective)
	
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

func update_objective():
	if(objective == "urgent explore" && hunger < 90):
		return "urgent explore"
	if(hunger < 90):
		return "find food"
	elif(timer < 5):
		return "idle"
	else:
		return "explore"

func _on_tick_timeout():
	timer += 1
	if(hunger > 0):
		hunger -= 1
	if(hunger <= 0):
		health -= 1
	if(health <= 0):
		queue_free()

#func _on_vision_timer_timeout():
	#if (has_target == true):
		#pass
	#var overlaps = $Head/VisionCones.get_overlapping_bodies()
	##print(str(overlaps.size()) + " objects in view")
	#if overlaps.size() > 0:
		#if (contains_food(overlaps) == true):
			#if (hunger <= 70):
				#update_target_location(get_closest(overlaps))
				#has_target = true
				#has_destination = true
				#SPEED = 5.0
			#elif (!memory.has(get_closest(overlaps))):
				#memory.append(get_closest(overlaps))
		#pass
	#pass

func update_needs_visuals():
	bar.update(hunger, 100)
