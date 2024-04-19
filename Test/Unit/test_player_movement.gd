extends GutTest

var test_environment = load("res://test_environment.tscn")

var _environment = null
var _char = null

var go_to_params = ParameterFactory.named_parameters(
	["coords"],
	[
		[Vector3(15,0,-20)],
		[Vector3(-96,0,19)],
		[Vector3(-14,0,1)],
		[Vector3(-10,0,-10)]
		
	]
)
var speed_stat_params = ParameterFactory.named_parameters(
	["speed_stat","result"],
	[
		[.1,.7],
		[1.1,7.7],
		[1.2,8.4],
		[2,14],
		[0,0],
		[-1,-7]
		
	]
)

#var _sender = InputSender.new(Input)
#
func before_all():
	InputMap.add_action("ui_cancel")

func before_each():
	_environment = add_child_autofree(test_environment.instantiate())
	_char = _environment.get_node("char")

#func after_each():
	#_sender.release_all()
	#_sender.clear()

func test_verify_setup():
	assert_not_null(_char,"player exists")

func test_parameterized_speed_calc(params = use_parameters(speed_stat_params)):
	
	_char.calc_speed(params.speed_stat)
	
	#assert_eq(snapped(_char.movement_speed,.1),params.result,)
	assert_almost_eq(_char.movement_speed,params.result,0.000001)

	

func test_go_to_food():
	
	var food_item = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn").instantiate()
	food_item.position = Vector3(50,0,25)
	_char.mem.memory.append(food_item)
	_char.hunger = 49
	await wait_seconds(6)
	assert_eq(snapped(_char.position,Vector3(1,1,1)),Vector3(50,1,25))

func test_go_to():
	_char.nav.destination = Vector3(100,0,-200)
	_char.nav.navigating = true
	await wait_seconds(3)
	var expected = (Vector3(100,0,0) - Vector3(0,0,0)).normalized() * _char.movement_speed
	assert_eq(snapped(_char.velocity,Vector3(1,1,1)),snapped(expected,Vector3(1,1,1)))

func test_parameterized_go_to(params = use_parameters(go_to_params)):
	
	_char.nav.destination = params.coords
	_char.nav.navigating = true
	await wait_seconds(1)
	
	var expected = (params.coords - _char.global_transform.origin).normalized() * _char.movement_speed
	
	assert_eq(snapped(_char.velocity,Vector3(.1,1,.1)),snapped(expected,Vector3(.1,1,.1)))
	
	
func test_death():
	await wait_seconds(20)
	assert_not_null(_char,"char alive")
	await wait_seconds(29)
	assert_null(_char,"char died")

func test_testing():
	var num = 15.0
	var result = 15.10095130654
	assert_almost_eq(result,num,.2)
	
	
#func test_menu():
	#_sender.key_down(KEY_ESCAPE).wait('100f')
	#await(_sender.idle)
	#assert_true(_sender.is_key_pressed(KEY_ESCAPE))
	#assert_true(Input.is_key_pressed(KEY_ESCAPE))
	
	
	
	
	
	
