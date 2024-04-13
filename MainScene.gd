extends Node3D


func _ready():
	var newNode = Node3D.new();
	print(typeof(newNode))
	var dict = {
		"node" : newNode
	}
	var json_string = JSON.stringify(dict)
	#data: Variant, indent: String = "", sort_keys: bool = true, full_precision: bool = false
	var json = JSON.new()
	var error = json.parse(json_string)
	var data_received = json.data
	print(typeof(data_received["node"]))
func _process(delta):
	pass
#to avoid new terrain generation cliping through and falling
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("free_camera"):
			$Camera3D.set_current(true)
		if event.is_action_pressed("ui_cancel"):
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			var in_gameMenu = preload("res://In-game menu/In_gameMenu.tscn").instantiate()
			if(!has_node("In_gameMenu")):
				add_child(in_gameMenu)
		if event.is_action_pressed("TestInGameMenu"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


