class_name Card
extends Resource

enum Type {SPAWN}

@export_group("Card Attributes")
@export var id: String
@export var type: Type

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
