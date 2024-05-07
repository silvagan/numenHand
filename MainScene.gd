extends Node3D

@onready var orbital_view = get_node("%OrbitalView")
@onready var orbital_cam = get_node("%OrbitalCam")
var cam_rotation = Vector3(0,0,0)
var lookAngles
func _ready():
	pass

func _process(delta):
	pass
#to avoid new terrain generation cliping through and falling
func _input(event):
	if event is InputEventKey:
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
		if event.is_action_pressed("ui_left"):
			cam_rotation -= Vector3(0,.1,0)
			orbital_view.set_third_person_rotation(cam_rotation)
		if event.is_action_pressed("ui_right"):
			cam_rotation += Vector3(0,.1,0)
			orbital_view.set_third_person_rotation(cam_rotation)
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if %OrbitalCam.is_current():
				
				lookAngles = event.relative / 350
				lookAngles.y = clamp(lookAngles.y, PI /-2, PI / 2)
				var rot = Vector3(lookAngles.y, lookAngles.x, 0)
				cam_rotation += rot
				orbital_view.set_third_person_rotation(cam_rotation)


