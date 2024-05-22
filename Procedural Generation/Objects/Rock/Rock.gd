extends StaticBody3D

func _ready():
	$".".rotation.y = randf_range(0,360)
	var num = randf_range(.5,2)
	$".".scale = Vector3(num,num,num)
