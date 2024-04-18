extends GutTest

func test_get_closest_food_from_memory():	
	var player = preload("res://Character/CharacterMain.tscn").instantiate()
	player.position = Vector3(0,0,0)
	var player_memory = Memory.new()
	player_memory.ch = player
	var food1 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food1.position = Vector3(20,0,0)
	var food2 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food2.position = Vector3(10,0,0)
	var food3 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food3.position = Vector3(30,0,0)
	player_memory.memory.append(food1)
	player_memory.memory.append(food2)
	player_memory.memory.append(food3)
	var result = player_memory.get_closest_memory_item("berry_bush")
	assert_eq(result,food2)

func test_get_farthest_food_from_memory():	
	var player = preload("res://Character/CharacterMain.tscn").instantiate()
	player.position = Vector3(0,0,0)
	var player_memory = Memory.new()
	player_memory.ch = player
	
	var food1 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food1.position = Vector3(20,0,0)
	var food2 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food2.position = Vector3(30,0,0)
	var food3 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food3.position = Vector3(20,0,0)
	player_memory.memory.append(food1)
	player_memory.memory.append(food2)
	player_memory.memory.append(food3)
	var result = player_memory.get_farthest_memory_item("berry_bush")
	assert_eq(result,food2)

func test_player_mem_food_swap():	
	var player = preload("res://Character/CharacterMain.tscn").instantiate()
	player.position = Vector3(0,0,0)
	var player_memory = Memory.new()
	player_memory.ch = player
	
	var food1 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food1.position = Vector3(20,0,0)
	var food2 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food2.position = Vector3(30,0,0)
	var food3 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food3.position = Vector3(10,0,0)
	var food4 = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food4.position = Vector3(5,0,0)
	player_memory.memory.append(food1)
	player_memory.memory.append(food2)
	player_memory.memory.append(food3)
	var memory_food = player.position.distance_to(player_memory.get_farthest_memory_item("berry_bush").position)
	var seen_food = player.position.distance_to(food4.position)
	if (memory_food > seen_food): 
		player_memory.memory.erase(player_memory.get_farthest_memory_item("berry_bush"))
		player_memory.memory.append(food4)
	
	
	assert_eq(player_memory.memory,[food1,food3,food4])

func test_player_mem_size():	
	var player_memory = Memory.new()
	var result = player_memory.size
	assert_eq(result,3)


func test_player_mem_has_food():
	var player_memory = Memory.new()
	var result = player_memory.has_type("berry_bush")
	assert_eq(result,false)
	
func test_player_mem_has_food1():
	var player_memory = Memory.new()
	var berryBush = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	berryBush.position = Vector3(10,10,0)
	player_memory.memory.append(berryBush)
	var result = player_memory.has_type("berry_bush")
	assert_eq(result,true)

func test_player_mem_has_home():
	var player_memory = Memory.new()
	var result = player_memory.has_type("campfire")
	assert_eq(result,false)
