extends Control

func save():	
	var saveRes = SaveRes.new()
	var mainNode = get_parent()
	saveRes.save_data["terrain_mesh"] = mainNode.get_node("Terrain").get_node("MeshInstance3D").mesh
	saveRes.save_data["terrain_nav_mesh"] = mainNode.get_node("Terrain").navigation_mesh
	
	
	return saveRes

func save_game():
	#var save_game = FileAccess.open("user://savegame.save",FileAccess.WRITE)
	#
	#var json_string = JSON.stringify(save())
	#
	#save_game.store_line(json_string)
	ResourceSaver.save(save(),"user://savegame.tres")
	
	
func _on_continue_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()


func _on_save_pressed():
	save_game()


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
