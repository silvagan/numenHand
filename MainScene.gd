extends Node3D
#@export var terra: terrain
@onready var terra = $NavigationRegion/Terrain
var a = 1
func _ready():
	#terra.generating_mesh(a)
	#$NavigationRegion.bake_navigation_mesh()
	pass
func _process(delta):
	#if Input.is_action_pressed("num 6"):
		#terra.generating_mesh(a)
	#if Input.is_action_pressed("num 7"):
		#$NavigationRegion.bake_navigation_mesh()
	pass
#to avoid new terrain generation cliping through and falling
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("Generate_map"):
			$CharacterMain.position.y += 5
	