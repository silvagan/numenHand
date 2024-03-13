extends Node
#this is a script dedicated to the MEMORY of the character
#MEMORY
@onready var char = $"../.."
#set universal momery for storing objects
var memory = []
var size = 3

#gets the closest memory |subject to change|
func get_food_closest_memory():
	var m = memory[0]
	if memory.size() > 1:		
		for c in memory:
			var c1 = char.position.distance_to(c.position)
			var c2 = char.position.distance_to(m.position)
			if (c1 < c2):
				m = c
		
	return m

#removes invalid memory items
func update():
	for c in memory:
		if c.is_in_group("berry_bush"):
			if c.amount == 0:
				memory.erase(c)
