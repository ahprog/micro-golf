extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Capture exit 
	if Input.is_action_pressed("quit"):
		get_tree().change_scene("res://LevelSelection.tscn")
