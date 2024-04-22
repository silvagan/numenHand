class_name SavedGame
extends Resource
#var chars = []
#terrain save
@export var save_data = {
	"terrain_mesh" : null,
	"terrain_nav_mesh" : null,
}

#npc save data
@export var npcsData :Array[SavedData] = []
