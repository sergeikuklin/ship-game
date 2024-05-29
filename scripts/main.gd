extends Node2D

# Preload the Ship scene as a PackedScene
@onready var ship_scene = preload("res://scenes/Ship.tscn")
@onready var camera = get_node("Camera2D")

var selected_ship = null
var drawing_path = false
var path_points = []
var tolerance = 5.0

func _ready():
	# Spawn an initial ship for testing
	
	spawn_ship(Vector2(10, 10))
	spawn_ship(Vector2(100, 100))

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not drawing_path:
					selected_ship = get_ship_at_position(camera.get_global_mouse_position())
					
					if selected_ship:
						drawing_path = true
						path_points = [selected_ship.position]
			else:
				drawing_path = false
				if selected_ship:
					selected_ship.set_path(simplify_path(path_points, tolerance))
					selected_ship = null

	elif event is InputEventMouseMotion and drawing_path:
		if selected_ship:
			path_points.append(camera.get_global_mouse_position())

func get_ship_at_position(position):
	for ship in get_tree().get_nodes_in_group("ships"):
		if ship.get_global_position().distance_to(position) < ship.get_node("CollisionShape2D").shape.get_radius()*7:
			return ship
	return null

func spawn_ship(position):
	var ship = ship_scene.instantiate()
	ship.position = position
	add_child(ship)
	ship.add_to_group("ships")

func _process(_delta):
	queue_redraw()

func _draw():
	if drawing_path and selected_ship:
		for i in range(len(path_points) - 1):
			draw_line(path_points[i], path_points[i + 1], Color(1, 0, 0), 2)
			
			
func simplify_path(points, tolerance):
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
		var first_half = simplify_path(points.slice(0, index + 1), tolerance)
		var second_half = simplify_path(points.slice(index, points.size()), tolerance)

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
