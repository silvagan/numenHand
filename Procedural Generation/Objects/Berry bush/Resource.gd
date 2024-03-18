extends StaticBody3D

@onready var amount : int = randi_range(1,5)
var location : Vector3
var weight : int

var textmesh = TextMesh.new()

func _ready():
	textmesh.text = "Amount: %s" % [amount]
	textmesh.font_size = 100
	$MeshInstance3D2.mesh = textmesh

func update() -> bool:
	amount -= 1
	if amount == 0:
		queue_free()
		return true
	else:
		textmesh.text = "Amount: %s" % [amount]
		textmesh.font_size = 100
		$MeshInstance3D2.mesh = textmesh
		return false
	

