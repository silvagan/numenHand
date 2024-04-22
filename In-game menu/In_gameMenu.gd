extends Control

@onready var allNpcs = get_parent().get_node("Characters").get_children()
func save_data():	
	var savedGame :SavedGame = SavedGame.new()
	var mainNode = get_parent()
	savedGame.save_data["terrain_mesh"] = mainNode.get_node("Terrain").get_node("MeshInstance3D").mesh
	savedGame.save_data["terrain_nav_mesh"] = mainNode.get_node("Terrain").navigation_mesh
	
	var savedData : Array[SavedData] = []
	get_tree().call_group("game_events", "on_game_save",savedData)
	
	savedGame.npcsData = savedData
	return savedGame

func save_game():
	#var file = FileAccess.open("user://savegame.data",FileAccess.WRITE)
	#file.store_var(allNpcs[0].global_position)
	#file.close()
	
	#var json_string = JSON.stringify(save())
	
	#save_game.store_line(json_string)
	ResourceSaver.save(save_data(),"user://savegame.tres")
	
	
func _on_continue_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()


func _on_save_pressed():
	save_game()


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		queue_free()
