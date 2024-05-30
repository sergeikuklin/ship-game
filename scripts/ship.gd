extends Area2D

enum ShipSize { LARGE, MEDIUM, SMALL }

@export var size = ShipSize.MEDIUM
@export var nodeColor:Constants.NodeColor = Constants.NodeColor.RED

var speed = 200
var rotation_speed = 15
var path = []
var path_index = 0

func _ready():
	match size:
		ShipSize.LARGE:
			speed = 100
		

func _process(delta):
	if path.size() > 0 and path_index < path.size():
		follow_path(path, delta)
		
	elif path_index >= path.size():
		path.clear()
		path_index = 0
		
	if path.size() == 0:
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
	path = new_path
	path_index = 0
	
	
func unload():
	# Use timer to set up unloading time
	# Add points to the score after unloading
	# Remove ship or make player to release it from dock
	print('unloading')

func destroy():
	# Apply penalty to the score
	print('destroyed')
	queue_free()


# When hits land
func _on_body_entered(body):
	destroy()

func _on_area_entered(area):
	if area.is_in_group('docks'):
		print('Entered the dock')
	
		if nodeColor == area.nodeColor:
			unload()
		else:
			print('Wrong color')
	
	if area.is_in_group('ships'):
		destroy()
