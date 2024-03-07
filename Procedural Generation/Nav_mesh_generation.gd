extends NavigationRegion3D

@export var size : int = 64
@export var subdivide : int = 63
@export var amplitude : int = 16
@export var noise : FastNoiseLite = FastNoiseLite.new()
@export var rock_noise : FastNoiseLite = FastNoiseLite.new()

@export var min_height : float = 0
@export var max_height : float = 0

var seed

var rock_spawn_locations : PackedVector3Array
var rock_scene = preload("res://Procedural Generation/Objects/Rock/Rock.tscn")

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("Generate_map"):
			min_height = 0
			max_height = 0
			generating_nav_mesh()
		if event.is_action_pressed("spawn_objects"):
			for i in get_child_count():
				if get_child(i).is_in_group("rock"):
					get_child(i).queue_free()
			for i in rock_spawn_locations.size():
				var rock = rock_scene.instantiate()
				rock.position.x = rock_spawn_locations[i].x
				rock.position.y = rock_spawn_locations[i].y
				rock.position.z = rock_spawn_locations[i].z
				rock.rotation.y = randi_range(0,180)
				rock.scale.x = randf_range(1,2)
				add_child(rock)

func _ready():	
	$".".navigation_mesh = NavigationMesh.new()
	generating_nav_mesh()

func generating_nav_mesh():
	rock_spawn_locations.clear()
	for i in get_child_count():
		if get_child(i).is_in_group("rock"):
			get_child(i).queue_free()
	print("Generating Mesh..")
	
	seed = (Time.get_date_string_from_system()+Time.get_time_string_from_system()).to_int()
	noise.seed = seed
	rock_noise.seed = seed
	
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size,size)
	plane_mesh.subdivide_depth = subdivide
	plane_mesh.subdivide_width = subdivide
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh,0)
	var data = surface_tool.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]
			
	for i in vertices.size():
		var vertex = vertices[i]
		vertices[i].y = noise.get_noise_2d(vertex.x,vertex.z) * amplitude
		
		if(abs(rock_noise.get_noise_2d(vertex.x,vertex.z)) > 0.7):
			rock_spawn_locations.append(vertices[i])
		
		
		
		
		if vertices[i].y < min_height:
			min_height = vertices[i].y
		if vertices[i].y > max_height:
			max_height = vertices[i].y
	
	data[ArrayMesh.ARRAY_VERTEX] = vertices
	
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	
	surface_tool.create_from(array_mesh,0)
	surface_tool.generate_normals()
	$MeshInstance3D.mesh = surface_tool.commit()
	$StaticBody3D/CollisionShape3D.shape = array_mesh.create_trimesh_shape()
	
	$".".add_child($MeshInstance3D)
	$".".bake_navigation_mesh()
	
