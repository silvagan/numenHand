class_name Memory
extends Node
#this is a script dedicated to the MEMORY of the character
#MEMORY
@onready var ch = $"../.."

#node where all char are a child of
@onready var allCh = get_parent().get_parent().get_parent()
#set universal momery for storing objects
var memory = []
var size = 3


func get_first_food_item():
	for c in memory:
		if c != null and c.is_in_group("berry_bush"):
			return c
#gets the closest memory |subject to change|
func get_food_closest_memory():
	var m = get_first_food_item()
	if memory.size() > 1:		
		for c in memory:
			if c != null and c.is_in_group("berry_bush"):
				var c1 = ch.position.distance_to(c.position)
				var c2 = ch.position.distance_to(m.position)
				if (c1 < c2):
					m = c
		
	return m
func get_food_farthest_memory():
	var m = get_first_food_item()
	if memory.size() > 1:		
		for c in memory:
			if c != null and c.is_in_group("berry_bush"):
				var c1 = ch.position.distance_to(c.position)
				var c2 = ch.position.distance_to(m.position)
				if (c1 > c2):
					m = c
		
	return m

func has_home():
	for c in memory:
		if c != null and c.is_in_group("Campfire"):
			return true
	return false
	
func has_food():
	for c in memory:
		if c != null and c.is_in_group("berry_bush"):
			return true
	return false
	
func home_location():
	for c in memory:
		if c != null and c.is_in_group("Campfire"):
			return c.position
#removes invalid memory items
func update():
	for char in allCh.get_children():
		for c in char.mem.memory:
			if c != null and c.is_in_group("berry_bush"):
				if c.amount == 0:
					char.mem.memory.erase(c)
