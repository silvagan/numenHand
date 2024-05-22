extends StaticBody3D

@onready var amount : int = randi_range(1,4)
var location : Vector3
var weight : int

var textmesh = TextMesh.new()


var distance = 5
var angle = 0
var newCordsX
var newCordsZ
var collision
var spawnCoords :Vector3

@onready var marker = $marker
@onready var spawn_radius = $spawnRadius

var newBeryBush = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn")

func _ready():
	textmesh.text = "berries: %s" % [amount]
	textmesh.font_size = 80
	textmesh
	$MeshInstance3D2.mesh = textmesh
	
	$Timer.start(1)

func update() -> bool:
	amount -= 1
	if amount == 0:
		queue_free()
		return true
	else:
		textmesh.text = "berries: %s" % [amount]
		textmesh.font_size = 80
		$MeshInstance3D2.mesh = textmesh
		return false
	





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
	await get_tree().create_timer(.1).timeout
	
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
		await get_tree().create_timer(.01).timeout
		counter +=1
	
	if spawn:
		var tree = newBeryBush.instantiate()
		tree.position = spawnCoords
		get_parent().add_child(tree)
