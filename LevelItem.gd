extends Button

signal level_selected(num)

var level_num: int
var locked: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_level_num(num: int):
	locked = false
	text = str(num)
	level_num = num

func _on_LevelItem_pressed():
	if locked:
		return
	emit_signal("level_selected", level_num)
