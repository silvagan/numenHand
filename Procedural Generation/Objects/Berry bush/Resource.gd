extends StaticBody3D

@onready var amount : int = randi_range(1,4)
var location : Vector3
var weight : int

var textmesh = TextMesh.new()

func _ready():
	textmesh.text = "berries: %s" % [amount]
	textmesh.font_size = 80
	textmesh
	$MeshInstance3D2.mesh = textmesh

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
	



