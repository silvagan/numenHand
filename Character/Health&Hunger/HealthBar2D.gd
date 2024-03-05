extends TextureProgressBar

var bar_red = preload("res://Character/Health&Hunger/barHorizontal_red_mid 200.png")
var bar_green = preload("res://Character/Health&Hunger/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://Character/Health&Hunger/barHorizontal_yellow_mid 200.png")


func update_bar(amount, full):
	texture_progress = bar_green
	if amount < full * 0.70:
		texture_progress = bar_yellow
	if amount < full * 0.40:
		texture_progress = bar_red
	value = amount
