extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var title_instance
var start_title_position = Vector2(130, -500) 
var target_title_position = Vector2(130, -100) 

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_menu_music()
	draw_grid()
	draw_title()

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
	AudioManager.play_game_music()

func draw_title():
	var scene = load("res://Title.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("Title")
	scene_instance.position = start_title_position
	add_child(scene_instance)
	title_instance = scene_instance

func _process(delta):
	var distance = (target_title_position - title_instance.position)
	if distance.length() > 10:
		title_instance.position += distance * delta * 2

func clear_grid():
	for n in get_children():
		remove_child(n)
		n.queue_free()
