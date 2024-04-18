extends GutTest

var test_environment = load("res://test_environment.tscn")

var _environment = null
var _char = null

func before_each():
	_environment = add_child_autofree(test_environment.instantiate())
	_char = _environment.get_node("char")

func test_verify_setup():
	assert_not_null(_char,"player exists")

func test_go_to_food():
	var food_item = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food_item.amount = 1
	food_item.position = Vector3(50,0,25)
	_char.mem.memory.append(food_item)
	_char.hunger = 49
	await wait_seconds(6)
	assert_eq(snapped(_char.position,Vector3(1,1,1)),Vector3(50,1,25))

func test_death():
	await wait_seconds(20)
	assert_not_null(_char,"char alive")
	await wait_seconds(29)
	assert_null(_char,"char died")
