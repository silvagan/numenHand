extends StaticBody3D

var amount : int
var location : Vector3
var weight : int
var pickable := true

var textmesh = TextMesh.new()

func _ready():
	textmesh.text = "Amount: %s" % [amount]
	textmesh.font_size = 100
	$MeshInstance3D2.mesh = textmesh

func update():
	pickable = false
	amount -= 1
	if amount == 0:
		queue_free()
	else:
		$Timer.start()
		textmesh.text = "Amount: %s" % [amount]
		textmesh.font_size = 100
		$MeshInstance3D2.mesh = textmesh
	


func _on_timer_timeout():
	pickable = true
	$Timer.stop()
