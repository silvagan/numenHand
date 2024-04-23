class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

@export var card: Card : set = _set_card

@onready var panel = $Panel
@onready var icon = $Icon

@onready var color: ColorRect = $Color
@onready var state: Label = $State

@onready var drop_point_detector = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] = []

func _ready() -> void:
	card_state_machine.init(self)
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	
func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	card = value
	icon.texture = card.icon
	
func _on_drop_point_detector_area_entered(area):
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area):
	targets.erase(area)

signal spawn_item(item:String)
func _on_card_released_state_spawn_item(item):
	spawn_item.emit(item)
