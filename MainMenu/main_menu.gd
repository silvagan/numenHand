extends Control


func _on_new_game_pressed():
	Globals.LOADED = false
	get_tree().change_scene_to_file("res://MainScene.tscn")


func _on_load_game_pressed():
	#if(!FileAccess.file_exists("user://savegame.save")):
		#return
	#var save_game = FileAccess.open("user://savegame.save",FileAccess.READ)
	#while(save_game.get_position() < save_game.get_length()):
		#var json_string = save_game.get_line()
		#var json = JSON.new()
		#var parse_result = json.parse(json_string)
		#var node_data = json.get_data()
		#print(node_data["terrain"])
		
	Globals.LOADED = true
	get_tree().change_scene_to_file("res://MainScene.tscn")
	


func _on_settings_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()
