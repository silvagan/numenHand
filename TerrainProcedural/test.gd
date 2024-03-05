@tool
extends Sprite2D

func _ready():
	pass


func _process(delta):
	if Engine.is_editor_hint():
		$".".rotation += 90 * delta
		$".".position.x += 90 * delta
