extends NavigationRegion3D

@export var size : int = 64
@export var subdivide : int = 63
@export var amplitude : int = 16
@export var noise : FastNoiseLite = FastNoiseLite.new()
@export var bush_noise : FastNoiseLite = FastNoiseLite.new()

@export var min_height : float = 0
@export var max_height : float = 0

var seed

var bush_spawn_locations : PackedVector3Array
var berry_bush_scene = preload("res://Procedural Generation/Objects/Berry bush/Berry_bush.tscn")

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("Generate_map"):
			min_height = 0
			max_height = 0
			generating_nav_mesh()
		if event.is_action_pressed("spawn_objects"):
			for i in get_child_count():
				if get_child(i).is_in_group("berry_bush"):
					get_child(i).queue_free()
			for i in bush_spawn_locations.size():
				var bush = berry_bush_scene.instantiate()
				bush.position.x = bush_spawn_locations[i].x
				bush.position.y = bush_spawn_locations[i].y
				bush.position.z = bush_spawn_locations[i].z
				bush.rotation.y = randi_range(0,180)
				bush.scale.x = randf_range(1,2)
				add_child(bush)

func _ready():	
	$".".navigation_mesh = NavigationMesh.new()
	generating_nav_mesh()

func generating_nav_mesh():
	bush_spawn_locations.clear()
	for i in get_child_count():
		if get_child(i).is_in_group("berry_bush"):
			get_child(i).queue_free()
	print("Generating Mesh..")
	
	seed = (Time.get_date_string_from_system()+Time.get_time_string_from_system()).to_int()
	noise.seed = seed
	bush_noise.seed = seed
	
	
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
		
		if(abs(bush_noise.get_noise_2d(vertex.x,vertex.z)) > 0.9):
			bush_spawn_locations.append(vertices[i])
			var bush = berry_bush_scene.instantiate()
			bush.position.x = vertices[i].x
			bush.position.y = vertices[i].y
			bush.position.z = vertices[i].z
			bush.location = vertices[i]
			bush.amount = randi_range(1,5)
			bush.weight = randi_range(1,5)
			add_child(bush)
		
		
		
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
	await get_tree().create_timer(1).timeout
	$".".navigation_mesh.set_vertices([Vector3(10,-10,10),Vector3(20,-10,10),Vector3(15,-10,20)])
	$".".bake_navigation_mesh()

