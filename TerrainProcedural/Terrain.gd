@tool
extends StaticBody3D

@export var generate_mesh: bool: set = generating_mesh
@export var size : int = 64
@export var subdivide : int = 63
@export var amplitude : int = 16
@export var noise : FastNoiseLite = FastNoiseLite.new()
@export var tree_noise : FastNoiseLite = FastNoiseLite.new()

@export var min_height : float = 0
@export var max_height : float = 1

@export var tree_scene : PackedScene

var asdf : bool = true
var tree_spawn_location : PackedVector3Array

func generating_mesh(a):
	if Engine.is_editor_hint():
		print("Generating Mesh..")
		var seed = (Time.get_date_string_from_system()+Time.get_time_string_from_system()).to_int()
		
		noise.seed = seed
		tree_noise.seed = 1-seed
		for i in get_child_count():
			if get_child(i).is_in_group("tree"):
				get_child(i).queue_free()
		
		var plane_mesh = PlaneMesh.new()
		plane_mesh.size = Vector2(size,size)
		plane_mesh.subdivide_depth = subdivide
		plane_mesh.subdivide_width = subdivide
		
		var surface_tool = SurfaceTool.new()
		surface_tool.create_from(plane_mesh,0)
		var data = surface_tool.commit_to_arrays()
		var vertices = data[ArrayMesh.ARRAY_VERTEX]
		
		var tree_cords
		var counter = 0
		var counter1 = 0
		
		for i in vertices.size():
			var vertex = vertices[i]
			vertices[i].y = noise.get_noise_2d(vertex.x,vertex.z) * amplitude
			tree_cords = abs(snapped(tree_noise.get_noise_2d(vertex.x,vertex.z),0.01))
			
			#await get_tree().create_timer(1).timeout
			#-----------------------SPAWNS TREES
			if(tree_cords > 0.75):
				#print(tree_cords)
				#pass
				var tree = tree_scene.instantiate()
				tree.rotation.y = randi_range(0,360)
				tree.position.x = vertices[i].x + randi_range(-2,2)
				tree.position.y = vertices[i].y+1
				tree.position.z = vertices[i].z+ randi_range(-2,2)
				add_child(tree)
				
			
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
		$CollisionShape3D.shape = array_mesh.create_trimesh_shape()
		
		#all vertices are in a 1d array
		#but the array creates a square
		#a single row has x amount of indexes
		#x = subdivide + 2
		#column has "subdivide + 1" rows 
		#var tree = tree_scene.instantiate()
		#tree.position.x = vertices[0].x
		#tree.position.z = vertices[0].z
		#tree.position.y = vertices[0].y
		#add_child(tree)
		#tree.position.x = vertices[12].x
		#tree.position.z = vertices[12].z
		#tree.position.y = vertices[12].y
		#add_child(tree)
		#tree.position.x = vertices[24].x
		#tree.position.z = vertices[24].z
		#tree.position.y = vertices[24].y
		#add_child(tree)
		
		#add_child(tree.instantiate())
		#print(get_child_count())
		#get_child(get_child_count()-1).queue_free()
		#print(get_child_count())
		
		
		
		
		#var tempNoise = FastNoiseLite.new()
		#tempNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX
		#var noiseImage = tempNoise.get_image(10,10)
		#noiseImage.save_png("res://noisetest.png")
		#
		#tempNoise.fractal_octaves = 1
		##print(tempNoise)
		#for i in 10:
			#for j in 10:
				#pass
				#print(snapped(tempNoise.get_noise_2d(i,j),0.01))
				#if snapped(tempNoise.get_noise_2d(i,j),0.01) >= 0.55:
					#print("spawned")
					#$".".add_child(tree.instantiate())
		
		#for i in tempNoise.get_method_list().size():
			#print(tempNoise.get_method_list()[i])
			#print("\n\n")
		
		

"""func _ready():
	if asdf:
		$Timer.start(5)


func _on_timer_timeout():
	if !Engine.is_editor_hint():
		
		var capture = get_viewport().get_texture().get_image()
		

		var _time = Time.get_date_string_from_system()

		var filename = "test.png"
		print(filename)

		capture.save_png(filename)
		$Timer.stop()"""


func _on_button_pressed():
		print("Generating Mesh..")
		var plane_mesh = PlaneMesh.new()
		plane_mesh.size = Vector2(size,size)
		plane_mesh.subdivide_depth = subdivide
		plane_mesh.subdivide_width = subdivide
		
		var surface_tool = SurfaceTool.new()
		surface_tool.create_from(plane_mesh,0)
		var data = surface_tool.commit_to_arrays()
		var vertices = data[ArrayMesh.ARRAY_VERTEX]
		
		var tree_cords
		var counter = 0
		for i in vertices.size():
			var vertex = vertices[i]
			vertices[i].y = noise.get_noise_2d(vertex.x,vertex.z) * amplitude
			tree_cords = abs(snapped(tree_noise.get_noise_2d(vertex.x,vertex.z),0.01))
			
			if(tree_cords > 0.75):
				#print(tree_cords)
				
				tree_spawn_location.append(vertices[i])
				counter += 1
				tree_spawn_location[0].x
			
			
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
		$CollisionShape3D.shape = array_mesh.create_trimesh_shape()


func _on_button_2_pressed():
	for i in get_child_count():
			if get_child(i).is_in_group("tree"):
				get_child(i).queue_free()
	for i in tree_spawn_location.size():
		var tree = tree_scene.instantiate()
		tree.rotation.y = randi_range(0,360)
		tree.position.x = tree_spawn_location[i].x
		tree.position.y = tree_spawn_location[i].y
		tree.position.z = tree_spawn_location[i].z
		add_child(tree)

func _process(delta):
	#if Input.is_action_pressed("num 6"):
		#var a = 1
		#generating_mesh(a)
	#if Input.is_action_pressed("num 7"):
		#$NavigationRegion.bake_navigation_mesh()
	pass
