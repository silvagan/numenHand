extends Node3D


func _ready():
	pass


func _process(delta):
	pass
#to avoid new terrain generation cliping through and falling
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("free_camera"):
			$Camera3D.set_current(true)
		if event.is_action_pressed("ui_cancel"):
			if(!has_node("In_gameMenu")):
				var in_gameMenu = preload("res://In-game menu/In_gameMenu.tscn").instantiate()
				add_child(in_gameMenu)
				get_tree().paused = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if event.is_action_pressed("TestInGameMenu"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if event.is_action_pressed("Pause"):
			$Characters.get_child(0).process_mode = Node.PROCESS_MODE_DISABLED


