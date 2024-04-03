extends CanvasLayer

@onready var item = preload("res://Ball/Ball.tscn")
var toggled := false

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
	spawn_item.emit("BerryBush",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "BerryBush"

func _on_tree_toggled(toggled_on):
	if $Control/BerryBush.button_pressed == true:
		$Control/BerryBush.button_pressed = !toggled_on
	if $Control/Rock.button_pressed == true:
		$Control/Rock.button_pressed = !toggled_on
	if $Control/Character.button_pressed == true:
		$Control/Character.button_pressed = !toggled_on
	if $Control/WaterPond.button_pressed == true:
		$Control/WaterPond.button_pressed = !toggled_on
	spawn_item.emit("Tree",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "Tree"

func _on_rock_toggled(toggled_on):
	if $Control/Tree.button_pressed == true:
		$Control/Tree.button_pressed = !toggled_on
	if $Control/BerryBush.button_pressed == true:
		$Control/BerryBush.button_pressed = !toggled_on
	if $Control/Character.button_pressed == true:
		$Control/Character.button_pressed = !toggled_on
	if $Control/WaterPond.button_pressed == true:
		$Control/WaterPond.button_pressed = !toggled_on
	spawn_item.emit("Rock",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "Rock"

func _on_character_toggled(toggled_on):
	if $Control/Tree.button_pressed == true:
		$Control/Tree.button_pressed = !toggled_on
	if $Control/BerryBush.button_pressed == true:
		$Control/BerryBush.button_pressed = !toggled_on
	if $Control/Rock.button_pressed == true:
		$Control/Rock.button_pressed = !toggled_on
	if $Control/WaterPond.button_pressed == true:
		$Control/WaterPond.button_pressed = !toggled_on
	spawn_item.emit("Ch",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "Ch"

func _on_water_pond_toggled(toggled_on):
	if $Control/Tree.button_pressed == true:
		$Control/Tree.button_pressed = !toggled_on
	if $Control/BerryBush.button_pressed == true:
		$Control/BerryBush.button_pressed = !toggled_on
	if $Control/Rock.button_pressed == true:
		$Control/Rock.button_pressed = !toggled_on
	if $Control/Character.button_pressed == true:
		$Control/Character.button_pressed = !toggled_on
	spawn_item.emit("WaterPond",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "WaterPond"


func _on_berry_bush_mouse_entered():
	spawn_item.emit("BerryBush",false)
	$Control/BerryBush.disabled = true
	$Control/BerryBush.disabled = false

func _on_tree_mouse_entered():
	spawn_item.emit("Tree",false)
	$Control/Tree.disabled = true
	$Control/Tree.disabled = false

func _on_rock_mouse_entered():
	spawn_item.emit("Rock",false)
	$Control/Rock.disabled = true
	$Control/Rock.disabled = false
	
func _on_character_mouse_entered():
	spawn_item.emit("Ch",false)
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
	spawn_item.emit("Campfire",true)

func _on_rest_pressed():
	for c in get_parent().get_node("Characters").get_children():
		c.objective = "go_rest"
