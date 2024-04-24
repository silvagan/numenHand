extends CardState

var played: bool

var type : String
#@export var card: Card : set = _set_type
#
#
#func _set_type(value: Card) -> void:
	#if not is_node_ready():
		#await ready
	#card = value
	#type = card.id

func enter() -> void:
	type = $"../..".card.id
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "RELEASED"
	
	played = false
	
	if not card_ui.targets.is_empty():
		played = true
		print("play card for target(s) ", card_ui.targets)
	
signal spawn_item(item:String)

func on_input(_event: InputEvent) -> void:
	if played:
		spawn_item.emit(type)
		get_parent().get_parent().queue_free()
		return
	
	transition_requested.emit(self, CardState.State.BASE)
