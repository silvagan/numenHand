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


func get_first_item(type):
	for c in memory:
		if c != null and c.is_in_group(type):
			return c

func get_closest_memory_item(type):
	var m = get_first_item(type)
	if memory.size() > 1:		
		for c in memory:
			if c != null and c.is_in_group(type):
				var c1 = ch.position.distance_to(c.position)
				var c2 = ch.position.distance_to(m.position)
				if (c1 < c2):
					m = c
		
	return m

func get_farthest_memory_item(type):
	var m = get_first_item(type)
	if memory.size() > 1:		
		for c in memory:
			if c != null and c.is_in_group(type):
				var c1 = ch.position.distance_to(c.position)
				var c2 = ch.position.distance_to(m.position)
				if (c1 > c2):
					m = c
		
	return m

func has_type(type):
	for c in memory:
		if c != null and c.is_in_group(type):
			return true
	return false
	
func home_location():
	for c in memory:
		if c != null and c.is_in_group("Campfire"):
			return c.position
#removes invalid memory items
#func update():
	#for char in allCh.get_children():
		#for c in char.mem.memory:
			#if c != null and c.is_in_group("berry_bush"):
				#if c.amount == 0:
					#char.mem.memory.erase(c)
func update():
	for char in allCh.get_children():
		for c in char.mem.memory:
			if c == null:
				char.mem.memory.erase(c)
