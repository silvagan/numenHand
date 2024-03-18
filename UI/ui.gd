extends CanvasLayer

@onready var item = preload("res://Ball/Ball.tscn")
var toggled := false

signal spawn_item(item:String, state:bool)
var prev_item



func _on_berry_bush_toggled(toggled_on):
	spawn_item.emit("BerryBush",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "BerryBush"


func _on_tree_toggled(toggled_on):
	spawn_item.emit("Tree",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "Tree"

func _on_rock_toggled(toggled_on):
	spawn_item.emit("Rock",toggled_on)
	toggled=toggled_on
	if toggled_on:
		prev_item = "Rock"


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


func _on_berry_bush_mouse_exited():
	spawn_item.emit(prev_item,toggled)


func _on_tree_mouse_exited():
	spawn_item.emit(prev_item,toggled)


func _on_rock_mouse_exited():
	spawn_item.emit(prev_item,toggled)
