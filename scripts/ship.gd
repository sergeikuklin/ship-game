extends CharacterBody2D

enum ShipSize { LARGE, MEDIUM, SMALL }

@export var size = ShipSize.MEDIUM
@export var nodeColor:Constants.NodeColor = Constants.NodeColor.RED

var speed = 300
var rotation_speed = 15
var path = []
var path_index = 0

func _ready():
		#if path.size() == 0:
		#path = default_path
	match size:
		ShipSize.LARGE:
			speed = 100
		


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


func set_path(new_path):
	path = new_path
	path_index = 0
	
	
func unload():
	print('unloading')
