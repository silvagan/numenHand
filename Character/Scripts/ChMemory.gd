extends Node
var memory = []

func get_food_closest_memory():
	var m = memory[0]
	for c in memory:
		var c1 = $".".distance_to(c)
		var c2 = $".".distance_to(m)
		if (c1 < c2):
			m = c
	return m
