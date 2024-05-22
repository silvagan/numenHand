class_name Hand
extends HBoxContainer

@onready var card_ui := preload("res://card_UI/card_ui.tscn")
var res : Card

func _ready() -> void:
	for child in get_children():
		var card_ui := child as CardUI
		card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
		
func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.reparent(self)


func _on_draw_card_button_down():
	var new_card_ui := card_ui.instantiate()
	new_card_ui.connect("spawn_item", $"../.."._on_card_ui_spawn_item)
	add_child(new_card_ui)
	get_random_card(new_card_ui.card, new_card_ui.icon)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = res
	#new_card_ui.parent = self
	
func draw_card():
	var new_card_ui := card_ui.instantiate()
	new_card_ui.connect("spawn_item", $"../.."._on_card_ui_spawn_item)
	add_child(new_card_ui)
	get_random_card(new_card_ui.card, new_card_ui.icon)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = res
	#new_card_ui.parent = self

func get_random_card(card, icon):
	var n = randi() % (4) + 1
	match n:
		1:
			res = preload("res://cards/berry_bush.tres")
		2:
			res = preload("res://cards/lone_hand.tres")
		3:
			res = preload("res://cards/tree.tres")
		4:
			res = preload("res://cards/water_pond.tres")
