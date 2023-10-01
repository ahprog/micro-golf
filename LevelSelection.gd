extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_grid()

func draw_grid():
	clear_grid()
	for i in range(1, Global.LEVEL_COUNT + 1):
		var scene = load("res://LevelItem.tscn")
		var scene_instance = scene.instance()
		scene_instance.set_name("LevelItem")
		add_child(scene_instance)
		if i <= Global.level_unlocked:
			scene_instance.set_level_num(i)
			scene_instance.connect("level_selected", self, "_on_level_selected")

func _on_level_selected(level_num):
	Global.current_level = level_num
	get_tree().change_scene("res://levels/" + str(level_num) + ".tscn")

func clear_grid():
	for n in get_children():
		remove_child(n)
		n.queue_free()
