extends Node2D

export var ball_speed = 100
export var max_reflections = 30  # Maximum number of reflections to compute
export var max_distance = 5000

var intersection_points: Array = []
var reflection_directions: Array = []

var UP = Vector2(0, -1)
var RIGHT = Vector2(1, 0)
var DOWN = Vector2(0, 1)
var LEFT = Vector2(-1, 0)

var directions = []

func _ready():
	compute_directions()

func compute_directions():
	var total_steps = 4  # 3 intermediate directions + 1 for the next cardinal direction
	var angle_step = PI / 2 / total_steps  # PI/2 is 90 degrees in radians
	
	var current_direction = UP
	for cardinal in [RIGHT, DOWN, LEFT, UP]:  # Ending with UP to complete the circle
		for i in range(total_steps):
			var angle = i * angle_step
			var direction = Vector2(
				current_direction.x * cos(angle) - current_direction.y * sin(angle),
				current_direction.x * sin(angle) + current_direction.y * cos(angle)
			)
			directions.append(direction)
		current_direction = cardinal

func _process(delta):
	$Hole.position = get_global_mouse_position()
	
	if Input.is_action_just_released("hit_ball") && intersection_points.size() > 0:
		print($Hole.position)
	
	intersection_points.clear()
	for dir in directions:
		var rebounds = compute_rebounds(dir)
		intersection_points.append(rebounds)
	
	# Redraw the canvas
	update()

func compute_rebounds(direction) -> Array:
	var current_direction = direction
	var current_position = $Hole.position
	var current_collider
	
	var new_intersection_points: Array = []
	
	var remaining_distance = 5000
	var previous_remaining_distance
	var previous_remaining_direction
	for i in range(max_reflections):
		if remaining_distance < 0:
			new_intersection_points.append(new_intersection_points[-1] + previous_remaining_direction * previous_remaining_distance)
			break
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(current_position, current_position + current_direction * 10000, [ current_collider ])
		if result:
			previous_remaining_distance = remaining_distance
			previous_remaining_direction = reflect(current_direction, result.normal)
			var distance = current_position.distance_to(result.position)
			remaining_distance -= distance
			new_intersection_points.append(result.position)
			current_direction = reflect(current_direction, result.normal)
			current_position = result.position
			current_collider = result.collider
		else:
			break
	return new_intersection_points

func _draw():
	for i in range(intersection_points.size()):
#		for j in range(intersection_points[i].size() - 1):
#			draw_line(intersection_points[i][j], intersection_points[i][j+1], Color.white)
		if intersection_points[i].size() > 1:
			draw_line(intersection_points[i][-1], intersection_points[i][-2], Color.white)
			draw_circle(intersection_points[i][-1], 10, Color.red)
			
		

func reflect(D: Vector2, N: Vector2) -> Vector2:
	return D - 2 * D.dot(N) * N

