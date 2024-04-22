extends Node3D


func _ready():
	if Globals.LOADED == true:
		var saved_data : SavedGame = load("user://savegame.tres") as SavedGame
		
		for item in saved_data.npcsData:
			var scene = load(item.scene_path) as PackedScene
			var loaded_npc = scene.instantiate()
			
			add_child(loaded_npc)
			
			if loaded_npc.has_method("on_load"):
				loaded_npc.on_load(item)
