extends CanvasLayer

func _on_new_game_pressed():
	Globals.LOADED = false
	get_tree().change_scene_to_file("res://MainScene.tscn")

func _on_quit_pressed():
	get_tree().quit()
	
