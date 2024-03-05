extends CharacterBody3D

@export var look_sensitivity :float  = 0.5
var vertical_look_limit = 90

@export var speed :int = 10
var horizontal_velocity = Vector3.ZERO
@export var acceleration :int = 3

var gravity = -5.81
var vertical_velocity = Vector3.ZERO
@export var jump_strength :int = 10

@onready var head = $Head


func _input(event):
	if Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x)*look_sensitivity)
		head.rotate_x(deg_to_rad(-event.relative.y)*look_sensitivity)
		head.rotation_degrees.x = clamp(
			head.rotation_degrees.x,
			-vertical_look_limit,
			vertical_look_limit
		)


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED)
		
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"): direction -= global_transform.basis.z
	if Input.is_action_pressed("move_backward"): direction += global_transform.basis.z
	if Input.is_action_pressed("move_left"): direction -= global_transform.basis.x
	if Input.is_action_pressed("move_right"): direction += global_transform.basis.x
	horizontal_velocity = horizontal_velocity.lerp(speed*direction.normalized(),delta*acceleration)
	
	if is_on_floor(): vertical_velocity.y = jump_strength if Input.is_action_just_pressed("jump") else 0
	#else: vertical_velocity.y += gravity * delta
	
	velocity = horizontal_velocity + vertical_velocity
	move_and_slide()
