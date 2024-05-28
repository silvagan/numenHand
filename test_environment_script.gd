extends Node3D

var char = preload("res://Character/CharacterMain.tscn")
var tree = preload("res://Procedural Generation/Objects/Tree/tree.tscn")
var berry_bush = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn")
var water = preload("res://Procedural Generation/Objects/Water pond/WaterPond.tscn")

func _on_button_pressed():
	#var new_char = char.instantiate()
	#new_char.position= Vector3(1,1,1)
	#$".".add_child(new_char)
	for i in range(1,2):
		var new_char = char.instantiate()
		new_char.position= Vector3(randi_range(-50,50),1,randi_range(-50,50))
		$".".add_child(new_char)
	
	
func _process(delta):
	$CanvasLayer/Label.text = str(Engine.get_frames_per_second())

func _on_button_2_pressed():
	for i in range(1,11):
		var new_char = tree.instantiate()
		new_char.position= Vector3(randi_range(-50,50),1,randi_range(-50,50))
		$".".add_child(new_char)


func _on_button_3_pressed():
	for i in range(1,11):
		var new_char = char.instantiate()
		new_char.position= Vector3(randi_range(-50,50),1,randi_range(-50,50))
		$".".add_child(new_char)


func _on_button_5_pressed():
	for i in range(1,11):
		var new_char = berry_bush.instantiate()
		new_char.position= Vector3(randi_range(-50,50),1,randi_range(-50,50))
		$".".add_child(new_char)


func _on_button_4_pressed():
	for i in range(1,11):
		var new_char = water.instantiate()
		new_char.position= Vector3(randi_range(-50,50),1,randi_range(-50,50))
		$".".add_child(new_char)
