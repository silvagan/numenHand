@tool
extends StaticBody3D

#@export var generate_mesh: bool: set = generating_mesh
@export var size : int = 64
@export var subdivide : int = 63
@export var amplitude : int = 16
@export var noise : FastNoiseLite = FastNoiseLite.new()

@export var min_height : float = 0
@export var max_height : float = 1

var asdf : bool = true

#func generating_mesh(__):
	#if Engine.is_editor_hint():
		#print("Generating Mesh..")
		#var plane_mesh = PlaneMesh.new()
		#plane_mesh.size = Vector2(size,size)
		#plane_mesh.subdivide_depth = subdivide
		#plane_mesh.subdivide_width = subdivide
		#
		#var surface_tool = SurfaceTool.new()
		#surface_tool.create_from(plane_mesh,0)
		#var data = surface_tool.commit_to_arrays()
		#var vertices = data[ArrayMesh.ARRAY_VERTEX]
		#
		#
		#for i in vertices.size():
			#var vertex = vertices[i]
			#vertices[i].y = noise.get_noise_2d(vertex.x,vertex.z) * amplitude
			#
			#
			#if vertices[i].y < min_height:
				#min_height = vertices[i].y
			#if vertices[i].y > max_height:
				#max_height = vertices[i].y
				#
			#
		#data[ArrayMesh.ARRAY_VERTEX] = vertices
		#
		#var array_mesh = ArrayMesh.new()
		#array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
		#
		#surface_tool.create_from(array_mesh,0)
		#surface_tool.generate_normals()
		#
		#$MeshInstance3D.mesh = surface_tool.commit()
		#$CollisionShape3D.shape = array_mesh.create_trimesh_shape()
		
		

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
		
		
		for i in vertices.size():
			var vertex = vertices[i]
			vertices[i].y = noise.get_noise_2d(vertex.x,vertex.z) * amplitude
			
			
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
