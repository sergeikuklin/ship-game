extends Node2D

var selected_ship = null
var drawing_path = false
var path_points = []
var tolerance = 5.0
var alpha_value = 1.0
var tween
var is_game_over = false

func _input(event):
	
	if event is InputEventMouseButton:
		var mouse_position = event.position
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not drawing_path:
					selected_ship = get_ship_at_position(mouse_position)
					
					if selected_ship:
						drawing_path = true
						path_points = [selected_ship.position]
			else:
				drawing_path = false
				if selected_ship && is_instance_valid(selected_ship):
					selected_ship.set_path(simplify_path(path_points))
					selected_ship = null
					if tween:
						tween.kill()
					alpha_value = 1.0
					tween = get_tree().create_tween()
					tween.tween_property(self, "alpha_value", 0, 0.3)
					

	elif event is InputEventMouseMotion and drawing_path:
		var mouse_position = event.position
		
		if selected_ship:
			path_points.append(mouse_position)	
	
func get_ship_at_position(mouse_position):
	for ship in get_tree().get_nodes_in_group("ships"):
		if ship.get_global_position().distance_to(mouse_position) < ship.get_node("CollisionShape2D").shape.get_radius()*7:
			return ship
	return null

func _process(_delta):
	if is_game_over:
		return;
	handle_levels()
	queue_redraw()

func _draw():
	if drawing_path and selected_ship:
		for i in range(len(path_points) - 1):
			draw_line(path_points[i], path_points[i + 1], Color(255, 255, 255, 1), 6)
	else:
		for i in range(len(path_points) - 1):
			draw_line(path_points[i], path_points[i + 1], Color(255, 255, 255, alpha_value), 6)
			
			
	
func simplify_path(points):
	if points.size() < 3:
		return points

	var first_point = points[0]
	var last_point = points[points.size() - 1]

	var max_distance = 0
	var index = 0

	for i in range(1, points.size() - 1):
		var distance = point_line_distance(points[i], first_point, last_point)
		if distance > max_distance:
			max_distance = distance
			index = i

	if max_distance > tolerance:
		var first_half = simplify_path(points.slice(0, index + 1))
		var second_half = simplify_path(points.slice(index, points.size()))

		return first_half.slice(0, first_half.size() - 1) + second_half
	else:
		return [first_point, last_point]

func point_line_distance(point, line_start, line_end):
	var line_mag = line_start.distance_to(line_end)

	if line_mag == 0:
		return point.distance_to(line_start)

	var t = ((point.x - line_start.x) * (line_end.x - line_start.x) + (point.y - line_start.y) * (line_end.y - line_start.y)) / (line_mag * line_mag)

	if t < 0:
		return point.distance_to(line_start)
	elif t > 1:
		return point.distance_to(line_end)

	var projection = line_start + t * (line_end - line_start)
	return point.distance_to(projection)

func _on_area_exited(area):
	if area.is_in_group('ships'):
		area.queue_free()

func handle_levels():		
	var level1_ships_count = $Level1/Ships.get_child_count()
	if level1_ships_count == 0:
		if %GameManager.score >=100:
			%GameManager.change_level(2)
			$Level1.set_process_mode(PROCESS_MODE_DISABLED)
			$Level1.hide()
			$Level1/TileMap.set_layer_enabled(0, false)
			
			$Level2.set_process_mode(PROCESS_MODE_INHERIT)
			$Level2.show()
			$Level2/TileMap.set_layer_enabled(0, true)
		else:
			is_game_over = true
			%GameManager.handle_game_over()
	var level2_ships_count = $Level2/Ships.get_child_count()
	if level2_ships_count == 0:
		is_game_over = true		
		%GameManager.handle_game_over()
