extends Camera3D

@export var acceleration = 2500
@export var moveSpeed = 5.0
@export var mouseSpeed = 300.0

var velocity = Vector3.ZERO
var lookAngles = Vector2(-3.14, -1.4)
# Called when the node enters the scene tree for the first time.

signal spawn_coords(coords)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass#CHANGED
	lookAngles.y = clamp(lookAngles.y, PI /-2, PI / 2)
	set_rotation(Vector3(lookAngles.y, lookAngles.x, 0))
	var direction = updateDirection()
	if direction.length_squared() > 0:
		velocity += direction * acceleration * delta
	if velocity.length() > moveSpeed:
		velocity = velocity.normalized() * moveSpeed
		
		translate(velocity * delta)

func _input(event):
	pass#CHANGED
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			lookAngles -= event.relative / mouseSpeed
	#########################################################
	if event.is_action_pressed("mouse_left"):
		shoot_ray()
		
func updateDirection():
	var dir = Vector3()
	if(!get_parent().has_node("In_gameMenu")):
		if Input.is_action_pressed("move_forward"):
			dir += Vector3.FORWARD
		if Input.is_action_pressed("move_backward"):
			dir += Vector3.BACK
		if Input.is_action_pressed("move_left"):
			dir += Vector3.LEFT
		if Input.is_action_pressed("move_right"):
			dir += Vector3.RIGHT
		if Input.is_action_pressed("move_up"):
			dir += Vector3.UP
		if Input.is_action_pressed("move_down"):
			dir += Vector3.DOWN
		if dir == Vector3.ZERO:
			velocity = Vector3.ZERO
		
	return dir.normalized()


func _on_timer_timeout():
	pass # Replace with function body.
	

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result != { }:
		spawn_coords.emit(raycast_result.position)

