extends Area2D

var speed = 200
var rotation_speed = 15
var path = []
var path_index = 0
# Default path radius and center
var circle_radius = 200
var circle_center = Vector2(10, 10)
var circle_points_count = 36

#func _ready():
	#if path.size() == 0:
		#path = generate_circle_path(circle_center, circle_radius, circle_points_count)

func _process(delta):
	if path.size() > 0 and path_index < path.size():
		var target_position = path[path_index]
		var direction = (target_position - position).normalized()
		
		# Check if the direction vector has a non-zero length
		if direction.length() > 0:
			# Calculate rotation angle based on the direction vector
			var target_angle = direction.angle() + PI / 2 # Add 90 degrees (PI / 2 radians) to make the ship face its nose correctly

			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

			# Move ship towards the target position
			position += direction * speed * delta

		# Check if ship has reached the target position
		if position.distance_to(target_position) <= 10:
			path_index += 1
	elif path_index >= path.size():
		path.clear()
		path_index = 0
		#set_path(generate_circle_path(circle_center, circle_radius, circle_points_count))


func set_path(new_path):
	path = new_path
	path_index = 0

func generate_circle_path(center, radius, points_count):
	var points = []
	for i in range(points_count):
		var angle = 2 * PI * i / points_count
		var x = center.x + radius * cos(angle)
		var y = center.y + radius * sin(angle)
		points.append(Vector2(x, y))
	return points
