extends Node2D

export var enable_debug: bool

export var ball_speed = 100
const MAX_REFLECTIONS = 100  # Maximum number of reflections to compute
const MAX_DISTANCE = 5000

enum GameState { AIMING, BALL_ANIMATION, END }
var current_game_state = GameState.AIMING

var start_direction: Vector2
var intersection_points: Array = []
var reflection_directions: Array = []

var remaining_distance
var previous_remaining_distance: float
var previous_remaining_direction: Vector2

var start_point: Vector2
var target_intersection: int
var move_progress: float

var mouse_position: Vector2
var previous_mouse_position: Vector2
var aim_position: Vector2

func _ready():
	current_game_state = GameState.AIMING

func _process(delta):
	# Capture exit 
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	
	# Capture restart 
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	
	# Endgame
	if current_game_state == GameState.END:
		return
	
	# Retrieve input	
	if current_game_state == GameState.AIMING:
		# Capture aim keys
		if Input.is_action_pressed("aim_left"):
			aim_position = get_rotated_aim(aim_position, -delta * 0.075)
		elif Input.is_action_pressed("aim_right"):
			aim_position = get_rotated_aim(aim_position, delta * 0.075)
	
		# Capture aim mouse
		previous_mouse_position = mouse_position
		mouse_position = get_global_mouse_position()
		if mouse_position != previous_mouse_position:
			aim_position = mouse_position
		
		# Capture ball hit
		if Input.is_action_just_released("hit_ball") && intersection_points.size() > 0:
			hit_ball()
		else:
			# Compute rebounds	
			compute_rebounds()
	# Handle ball movement
	elif current_game_state == GameState.BALL_ANIMATION:
		update_ball_position(delta)
	
	# Redraw the canvas
	update()

func update_ball_position(delta):
	var target_point = intersection_points[target_intersection]
	var distance = start_point.distance_to(target_point)
	$Ball.position = start_point.linear_interpolate(target_point, move_progress)
	move_progress += (delta / distance) * remaining_distance
	if (move_progress > 1):
		start_point = target_point
		target_intersection += 1
		if target_intersection > intersection_points.size() - 1:
			current_game_state = GameState.END;
		move_progress = 0
		remaining_distance -= distance

func compute_rebounds():
	start_direction = (aim_position - $Ball.position).normalized()
	intersection_points.clear()
	reflection_directions.clear()
	
	var current_direction = start_direction
	var current_position = $Ball.position
	var current_collider
	remaining_distance = MAX_DISTANCE
	for i in range(MAX_REFLECTIONS):
		if remaining_distance < 0:
			break
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(current_position, current_position + current_direction * 10000, [ current_collider ])
		if result:
			var distance = current_position.distance_to(result.position)
			previous_remaining_distance = remaining_distance
			previous_remaining_direction = reflect(current_direction, result.normal)
			remaining_distance -= distance
			if remaining_distance > 0:
				intersection_points.append(result.position)
				reflection_directions.append(reflect(current_direction, result.normal))
				current_direction = reflection_directions[-1]
				current_position = intersection_points[-1]
				current_collider = result.collider
		else:
			break

func hit_ball():
	current_game_state = GameState.BALL_ANIMATION
	start_point = $Ball.position
	target_intersection = 0
	intersection_points.append(intersection_points[-1] + reflection_directions[-1] * previous_remaining_distance)
	remaining_distance = MAX_DISTANCE

func _draw():
	if current_game_state == GameState.BALL_ANIMATION:
		draw_circle(intersection_points[-1], 5, Color.red)
	elif current_game_state == GameState.AIMING:
		draw_line($Ball.position, $Ball.position + start_direction*100, Color.white)
		
	if intersection_points.size() > 0:
		draw_rebounds()


func draw_rebounds():
	var current_position = $Ball.position
	var alpha = 1
	var hints: float
	if current_game_state == GameState.BALL_ANIMATION:
		hints = intersection_points.size() - 4
	else:
		hints = intersection_points.size() - 3
	var alpha_d: float = (1 / hints)
	for i in range(intersection_points.size() - 1):
		if enable_debug:
			draw_line(intersection_points[i], intersection_points[i+1], Color.white)
		draw_circle(intersection_points[i], 10, Color(0, 1, 0, alpha))
		alpha -= alpha_d
	
	if enable_debug:
		draw_line(intersection_points[-2], intersection_points[-1], Color.red, 5)
		draw_circle(intersection_points[-1], 30, Color.red)
	

func reflect(D: Vector2, N: Vector2) -> Vector2:
	return D - 2 * D.dot(N) * N

func get_rotated_aim(baseAim: Vector2, angle_rad: float) -> Vector2:
	var direction = (baseAim - $Ball.position).normalized()
	direction = direction.rotated(angle_rad)
	var newAim = $Ball.position + direction * 100
	return newAim
