extends Node
#this is a script dedicated to the MEMORY of the character
#MEMORY

#set universal momery for storing objects
var memory = []

#gets the closest memory |subject to change|
func get_food_closest_memory():
	var m = memory[0]
	for c in memory:
		var c1 = $".".distance_to(c)
		var c2 = $".".distance_to(m)
		if (c1 < c2):
			m = c
	return m
