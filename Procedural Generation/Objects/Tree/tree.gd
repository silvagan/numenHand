extends StaticBody3D

@onready var amount : int = 5

var distance = 15
var angle = 0
var newCordsX
var newCordsZ
var collision
var spawnCoords :Vector3

@onready var ray = $RayCast3D
var textmesh = TextMesh.new()

var adult = true
@onready var marker = $marker
@onready var spawn_radius = $spawnRadius

var newTree = preload("res://Procedural Generation/Objects/Tree/tree.tscn")

signal felltree
func _ready():
	$".".rotation.y = randf_range(0,360)	
	#self.connect("felltree", $".."._draw_card)

	textmesh.text = "health: %s" % [amount]
	textmesh.font_size = 50
	$treehealth.mesh = textmesh
	#if adult:
		#$Timer.start(1)
		
func _process(delta):
	if not adult:
		scale += Vector3(.01,.01,.01)
	if scale.is_equal_approx(Vector3(4.0,4.0,4.0)) and not adult:
		adult = true
		reproduce.emit()
	
signal reproduce
	
func update() -> bool:
	amount -= 1
	if amount == 0:
		queue_free()
		felltree.emit()
		return true
	else:
		#textmesh.text = "health: %s" % [amount]
		#textmesh.font_size = 50
		#$treehealth.mesh = textmesh
		return false

	
	
	$Timer.start(1)


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
	
	#spawnCoords = Vector3(newCordsX,position.y,newCordsZ)
	spawnCoords = Vector3(newCordsX,position.y,newCordsZ)
	marker.set_global_position(spawnCoords)
	await get_tree().create_timer(.01).timeout
	
	while(marker.get_overlapping_areas() != [] || OoB == true):
		OoB = false
		if counter == 100:
			spawn = false
			break
		angle = randi_range(1,360)
		newCordsX = distance*cos(deg_to_rad(angle)) + global_position.x
		newCordsZ = distance*sin(deg_to_rad(angle)) + global_position.z
		if newCordsX > 50 || newCordsX < -50 || newCordsZ > 50 || newCordsZ < -50:
			OoB = true
		spawnCoords = Vector3(newCordsX,position.y,newCordsZ)
		marker.global_position = spawnCoords
		ray.global_position = spawnCoords
		
		await get_tree().create_timer(.1).timeout
		counter +=1
	
	
	if spawn:
		var tree = newTree.instantiate()
		tree.position = spawnCoords
		ray.force_raycast_update()
		await get_tree().create_timer(.2).timeout
		
		print(ray.get_collision_point().y)
		tree.position.y = ray.get_collision_point().y
		tree.adult = false;
		tree.scale *= .1
		get_parent().add_child(tree)
	
func _on_reproduce():
	$Timer.start(1)

