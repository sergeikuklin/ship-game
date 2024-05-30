extends Area2D

enum ShipSize { LARGE, MEDIUM, SMALL }

@export var size = ShipSize.MEDIUM
@export var node_color:Constants.NodeColor = Constants.NodeColor.RED

@onready var color_tile = $ColorTile
@onready var game_manager = %GameManager

var speed = 200
var rotation_speed = 15
var path = []
var path_index = 0
var is_entered_dock = false
func _ready():
	color_tile.material.set_shader_parameter('nodeColor', node_color)
			
	match size:
		ShipSize.LARGE:
			speed = 100
		

func _process(delta):
	if path.size() > 0 and path_index < path.size():
		follow_path(path, delta)
		
	elif path_index >= path.size():
		path.clear()
		path_index = 0
		
	if path.size() == 0 && !is_entered_dock:
		var forward_direction = Vector2(cos(rotation - PI / 2), sin(rotation - PI / 2))
		position += forward_direction * speed * delta


func follow_path(path, delta):
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
	if position.distance_to(target_position) <= 40:
		path_index += 1

func set_path(new_path):
	var closest_index = find_closest_point_index(new_path)

	path = new_path
	path_index = find_closest_point_index(new_path) 

	
func unload():
	# Use timer to set up unloading time
	# Add points to the score after unloading
	# Remove ship or make player to release it from dock
	print('unloading')
	
	game_manager.add_points(20)

func destroy():
	# Apply penalty to the score
	print('destroyed')
	game_manager.remove_points(20)
	
	queue_free()

func find_closest_point_index(points):
	if points.size() == 0:
		return 0

	var closest_index = 0
	var min_distance = global_position.distance_to(points[0])

	for i in range(1, points.size()):
		var distance = global_position.distance_to(points[i])
		if distance < min_distance:
			min_distance = distance
			closest_index = i

	return closest_index

# When hits land
func _on_body_entered(body):
	destroy()

func _on_area_entered(area):
	if area.is_in_group('docks'):
		print('Entered the dock')
	
		is_entered_dock = true
		
		if node_color == area.node_color:
			unload()
		else:
			print('Wrong color')
	
	if area.is_in_group('ships'):
		destroy()


func _on_area_exited(area):
	if area.is_in_group('docks'):
		is_entered_dock = false
		
		print('Left the dock')
