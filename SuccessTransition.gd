extends Container


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

	
func start_transition():
	yield(get_tree().create_timer(3.0), "timeout")
	if Global.current_level >= Global.LEVEL_COUNT:
		get_tree().change_scene("res://EndScene.tscn")
	else:
		Global.current_level += 1
		Global.level_unlocked = max(Global.level_unlocked, Global.current_level)
		get_tree().change_scene("res://levels/" + str(Global.current_level) + ".tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
