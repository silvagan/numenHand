extends StaticBody3D

var distance = 15
var angle = 0
var newCordsX
var newCordsZ
var collision
var spawnCoords :Vector3

@onready var marker = $marker
@onready var spawn_radius = $spawnRadius

var newTree = preload("res://Procedural Generation/Objects/Tree/tree.tscn")

func _ready():
	$".".rotation.y = randf_range(0,360)	
	
	#angle = randi_range(0,360)
	
	#newCordsX = distance*cos(deg_to_rad(angle)) + global_position.x
	#newCordsZ = distance*sin(deg_to_rad(angle)) + global_position.z
	#spawnCoords = Vector3(newCordsX,position.y,newCordsZ)
	#newCordsX = distance*cos(angle) + position.x
	#newCordsZ = distance*sin(angle) + position.z
	
	#spawnCoords = Vector3(newCordsX,position.y,newCordsZ)
	
	
	#marker.position = position
	#marker.global_position = Vector3.ZERO
	
	#print(position)	
	#print(global_position)	
	#print(spawnCoords)
	#print(marker.position)
	#print(marker.global_position)
	
	
	
	$Timer.start(1)
	
	

func _process(delta):
	pass

func _on_timer_timeout():
	$Timer.stop()
	var counter = 0
	var spawn = true;
	var OoB = false;
	angle = randi_range(1,360)
	newCordsX = distance*cos(deg_to_rad(angle)) + global_position.x
	newCordsZ = distance*sin(deg_to_rad(angle)) + global_position.z
	if newCordsX > 50 || newCordsX < -50 || newCordsZ > 50 || newCordsZ < -50:
		OoB = true
	
	spawnCoords = Vector3(newCordsX,position.y,newCordsZ)
	marker.set_global_position(spawnCoords)
	await get_tree().create_timer(.01).timeout
	
	if(marker.get_overlapping_areas() == []):
		print("empty")
	while(marker.get_overlapping_areas() != [] || OoB == true):
		OoB = false
		print(marker.get_overlapping_areas())
		if counter == 360:
			spawn = false
			break
		angle = randi_range(1,360)
		newCordsX = distance*cos(deg_to_rad(angle)) + global_position.x
		newCordsZ = distance*sin(deg_to_rad(angle)) + global_position.z
		if newCordsX > 50 || newCordsX < -50 || newCordsZ > 50 || newCordsZ < -50:
			OoB = true
		spawnCoords = Vector3(newCordsX,position.y,newCordsZ)
		marker.global_position = spawnCoords
		await get_tree().create_timer(.1).timeout
		counter +=1
	
	if spawn:
		var tree = newTree.instantiate()
		tree.position = spawnCoords
		get_parent().add_child(tree)
	
	
	
