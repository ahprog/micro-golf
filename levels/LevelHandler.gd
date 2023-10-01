extends Node2D

func set_ball_position(pos: Vector2):
	$Ball.global_position = pos
	
func get_ball_position() -> Vector2:
	return $Ball.global_position

func set_hole_scale(scale: Vector2):
	$Hole.global_scale = scale

func get_hole_position() -> Vector2:
	return $Hole.global_position

func set_ball_visible(visible: bool):
	$Ball.visible = visible
