#class_name MainChar
extends CharacterBody3D
#this is the MAIN character script
#MAIN

@export var seed = randi()
var t = RandomNumberGenerator.new()

#character needs
@export var hunger = 100
@export var health = 100
@export var thirst = 100
@export var exhaustion = 100


@onready var orbital_view = get_parent().get_parent().get_node("%OrbitalView")
@onready var orbital_cam = get_parent().get_parent().get_node("%OrbitalCam")


var _BASE_SPEED = 7
var movement_speed
var speed_stat 

var death = "Death_B"
var dead = "Death_B_Pose"
var isAlive = true


#character objective
@export var objective := "idle"
var prev_objective : String

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


@onready var model = $Rig
@onready var anim_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")

var textmesh = TextMesh.new()
var minutes = 0
var seconds = 0


#var last_floor = true
#var jumping = false
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	
	var randSpeed = RandomNumberGenerator.new()
	randSpeed.seed = seed
	speed_stat = snapped(randSpeed.randf_range(0.8,1.2),.1)
	
	calc_speed(speed_stat)
	
	textmesh.text = "%s \n %s \n %s : %s" % [objective,movement_speed,minutes, seconds]
	textmesh.font_size = 80
	textmesh
	$AliveTime.mesh = textmesh

func calc_speed(speed_stat):
		
	movement_speed = _BASE_SPEED * speed_stat
	

func _physics_process(delta):

	#velocity.y += -gravity * delta
	#if is_on_floor() and not last_floor:
		#jumping = false
		#anim_tree.set("parameters/conditions/grounded", true)
	## We're in the air, but we didn't jump
	#if not is_on_floor() and not jumping:
		#anim_state.travel("Jump_Idle")
		#anim_tree.set("parameters/conditions/grounded", false)
	#last_floor = is_on_floor()
	$Rig/Skeleton3D/Barbarian_Head.rotation=$Head.rotation
	$Rig/Skeleton3D/Barbarian_Head.position=$Head.position
	$Rig/Skeleton3D/Barbarian_Head.position.y -= 2.457
	if !isAlive:
		return

	if(exhaustion > 20):
		if(thirst < 50 or hunger < 50):
			movement_speed = _BASE_SPEED * speed_stat * 1.3
		else:
			movement_speed = _BASE_SPEED * speed_stat
	else:
		movement_speed = _BASE_SPEED * speed_stat * 0.8
	#update objective, visuals and body rotation
	objective = update_objective()
	update_needs_visuals()
	nav.update_body_rotation()
	
	print(objective)
	#print(thirst)
	#print(hunger)
	#act upon current objective
	match objective:
		"idle":
			nav.fall()
		"find food":
			nav.find_food()
		"eat":
			itr.eat()
		"cut":
			itr.cut()
		"find water":
			nav.find_water()
		"drink":
			itr.drink()
		"go sleep":
			pass
		"go_rest":
			nav.go_rest()
		"rest":
			itr.rest()
		"gather resources":
			pass
		"explore":
			nav.explore()
		"urgent explore food":
			nav.urgent_explore_food()
		"urgent explore water":
			nav.urgent_explore_water()
		"cut tree":
			nav.cut_tree()

#called on timer timeout
func _on_tick_timeout():
	if(hunger > 0):
		hunger -= 0.3
	if(thirst > 0):
		thirst -= 0.7
	if(hunger <= 0):
		health -= 1
	if(thirst <= 0):
		health -= 1
	if(exhaustion > 0):
		exhaustion -= 0.5
	if(health <= 0):
		isAlive =false
		anim_state.travel(death)
		anim_state.travel(dead)
		await get_tree().create_timer(4).timeout
		queue_free()

#updates the objective based on criteria
func update_objective():

	if !isAlive:
		return

	if(objective == "eat"):
		return "eat"

	if(objective == "drink"):
		return "drink"
	
	if(objective == "rest"):
		return "rest"
	
	if(objective == "cut"):
		return "cut"
		
	if(objective == "urgent explore food" && hunger < 50):
		return "urgent explore food"
	if(objective == "urgent explore water" && thirst < 50):
		return "urgent explore water"
	elif(hunger < 50 && objective != "urgent explore water"):
		return "find food"
	elif(thirst < 50 && objective != "urgent explore food"):
		return "find water"
	elif(exhaustion < 50 and mem.has_type("Campfire")):
		return "go_rest"
	elif($Temp.get_time_left() > 0):
		return "idle"

	elif(objective == "cut tree"):
		return "cut tree"
	else:
		return "explore"

#updates needs visuals
func update_needs_visuals():
	hebar.update(health, 100)
	hubar.update(hunger, 100)
	thbar.update(thirst, 100)
	exbar.update(exhaustion, 100)



func _on_interaction_rebake_mesh(location):
	$"../NavigationRegion3D".rebakeMesh(location)


func _on_alive_time_timeout():
	if(seconds == 59):
		seconds = 0
		minutes += 1
	else:
		seconds += 1
	textmesh.text = "%s \n %s \n %s : %s" % [objective,movement_speed,minutes, seconds]
	textmesh.font_size = 80
	textmesh
	$AliveTime.mesh = textmesh


#
#func _on_in_range_input_event(camera, event, position, normal, shape_idx):
	#if event is InputEventMouseButton:
		#if event.is_action_pressed("mouse_left"):
			#print(":SDf")
			#
			#

func on_game_save(saved_data:Array[SavedData]):
	var my_data :SavedData = SavedData.new()
	
	my_data.exhaustion = exhaustion
	my_data.health = health
	my_data.hunger = hunger
	my_data.thirst = thirst
	my_data.movement_speed = movement_speed
	my_data.position = global_position
	my_data.seed = seed
	my_data.speed_stat = speed_stat
	my_data.objective = objective
	my_data.memory = mem.memory
	my_data.scene_path = scene_file_path
	my_data.velocity = velocity
	my_data.destination = nav.destination
	
	saved_data.append(my_data)
	
func on_load(saved_data:SavedData):
	health = saved_data.health
	hunger = saved_data.hunger
	thirst = saved_data.thirst
	exhaustion = saved_data.exhaustion
	seed = saved_data.seed
	global_position = saved_data.position
	speed_stat = saved_data.speed_stat
	movement_speed = saved_data.movement_speed
	objective = saved_data.objective
	mem.memory = saved_data.memory
	velocity = saved_data.velocity
	nav.destination = saved_data.destination
	
	
	



func _on_in_range_input_event(camera, event, position, normal, shape_idx):
	if event is InputEvent:
		if event.is_action_pressed("mouse_right"):
			orbital_cam.set_current(true)
			$"../../FreeCam".position = orbital_cam.position
			orbital_view.set_follow_target_node(self)
			orbital_view.set_priority(1)
