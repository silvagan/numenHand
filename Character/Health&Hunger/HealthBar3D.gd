extends Sprite3D

@onready var bar = $SubViewport/HealthBar2D

func _ready():
	texture = $SubViewport.get_texture()
	
func update(value, max):
	bar.update_bar(value, max)
