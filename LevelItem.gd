extends Button

signal level_selected(num)

var icons: Array = [
	preload("res://sprites/level_icon/chiffre1.png"),
	preload("res://sprites/level_icon/chiffre2.png"),
	preload("res://sprites/level_icon/chiffre3.png"),
	preload("res://sprites/level_icon/chiffre4.png"),
	preload("res://sprites/level_icon/chiffre5.png"),
	preload("res://sprites/level_icon/chiffre6.png"),
	preload("res://sprites/level_icon/chiffre7.png"),
	preload("res://sprites/level_icon/chiffre8.png"),
	preload("res://sprites/level_icon/chiffre9.png"),
	preload("res://sprites/level_icon/chiffre10.png"),
	preload("res://sprites/level_icon/chiffre11.png"),
	preload("res://sprites/level_icon/chiffre12.png")
	]



var level_num: int
var locked: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_level_num(num: int):
	icon = icons[num - 1]
	locked = false
	level_num = num

func _on_LevelItem_pressed():
	if locked:
		return
	emit_signal("level_selected", level_num)
