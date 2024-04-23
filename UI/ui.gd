extends CanvasLayer

@onready var item = preload("res://Ball/Ball.tscn")
var toggled := false

var minutes = 0
var second = 0

signal spawn_item(item:String, state:bool)
var prev_item

func _on_berry_bush_toggled(toggled_on):
	if $Control/Tree.button_pressed == true:
		$Control/Tree.button_pressed = !toggled_on
	if $Control/Rock.button_pressed == true:
		$Control/Rock.button_pressed = !toggled_on
	if $Control/Character.button_pressed == true:
		$Control/Character.button_pressed = !toggled_on
	if $Control/WaterPond.button_pressed == true:
		$Control/WaterPond.button_pressed = !toggled_on
	spawn_item.emit("berry_bush",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "berry_bush"

func _on_tree_toggled(toggled_on):
	if $Control/BerryBush.button_pressed == true:
		$Control/BerryBush.button_pressed = !toggled_on
	if $Control/Rock.button_pressed == true:
		$Control/Rock.button_pressed = !toggled_on
	if $Control/Character.button_pressed == true:
		$Control/Character.button_pressed = !toggled_on
	if $Control/WaterPond.button_pressed == true:
		$Control/WaterPond.button_pressed = !toggled_on
	spawn_item.emit("tree",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "tree"

func _on_rock_toggled(toggled_on):
	if $Control/Tree.button_pressed == true:
		$Control/Tree.button_pressed = !toggled_on
	if $Control/BerryBush.button_pressed == true:
		$Control/BerryBush.button_pressed = !toggled_on
	if $Control/Character.button_pressed == true:
		$Control/Character.button_pressed = !toggled_on
	if $Control/WaterPond.button_pressed == true:
		$Control/WaterPond.button_pressed = !toggled_on
	spawn_item.emit("rock",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "rock"

func _on_character_toggled(toggled_on):
	if $Control/Tree.button_pressed == true:
		$Control/Tree.button_pressed = !toggled_on
	if $Control/BerryBush.button_pressed == true:
		$Control/BerryBush.button_pressed = !toggled_on
	if $Control/Rock.button_pressed == true:
		$Control/Rock.button_pressed = !toggled_on
	if $Control/WaterPond.button_pressed == true:
		$Control/WaterPond.button_pressed = !toggled_on
	spawn_item.emit("lone_hand",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "lone_hand"

func _on_water_pond_toggled(toggled_on):
	if $Control/Tree.button_pressed == true:
		$Control/Tree.button_pressed = !toggled_on
	if $Control/BerryBush.button_pressed == true:
		$Control/BerryBush.button_pressed = !toggled_on
	if $Control/Rock.button_pressed == true:
		$Control/Rock.button_pressed = !toggled_on
	if $Control/Character.button_pressed == true:
		$Control/Character.button_pressed = !toggled_on
	spawn_item.emit("water_pond",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "water_pond"


func _on_berry_bush_mouse_entered():
	spawn_item.emit("berry_bush",false)
	$Control/BerryBush.disabled = true
	$Control/BerryBush.disabled = false

func _on_tree_mouse_entered():
	spawn_item.emit("tree",false)
	$Control/Tree.disabled = true
	$Control/Tree.disabled = false

func _on_rock_mouse_entered():
	spawn_item.emit("rock",false)
	$Control/Rock.disabled = true
	$Control/Rock.disabled = false
	
func _on_character_mouse_entered():
	spawn_item.emit("lone_hand",false)
	$Control/Character.disabled = true
	$Control/Character.disabled = false

func _on_water_pond_mouse_entered():
	spawn_item.emit("WaterPond",false)
	$Control/WaterPond.disabled = true
	$Control/WaterPond.disabled = false

func _on_berry_bush_mouse_exited():
	spawn_item.emit(prev_item,toggled)


func _on_tree_mouse_exited():
	spawn_item.emit(prev_item,toggled)


func _on_rock_mouse_exited():
	spawn_item.emit(prev_item,toggled)


func _on_character_mouse_exited():
	spawn_item.emit(prev_item,toggled)


func _on_water_pond_mouse_exited():
	spawn_item.emit(prev_item,toggled)
	
func _on_campfire_pressed():
	spawn_item.emit("campfire",true)

func _on_rest_pressed():
	for c in get_parent().get_node("Characters").get_children():
		c.objective = "go_rest"

signal place_object_from_card(item:String)
func _on_card_ui_spawn_item(item):
	place_object_from_card.emit(item)
