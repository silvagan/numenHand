extends Node3D
#@export var terra: terrain

func _ready():
	#terra.generating_mesh(a)
	#$NavigationRegion.bake_navigation_mesh()
	pass
func _process(delta):
	pass
#to avoid new terrain generation cliping through and falling
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("free_camera"):
			$Camera3D.set_current(true)
		if event.is_action_pressed("pov_camera"):
			#$CharacterMain/Head/povCamera.set_current(true)
			pass
		if event.is_action_pressed("ui_cancel"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


