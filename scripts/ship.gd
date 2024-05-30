extends Area2D

enum ShipSize { LARGE, MEDIUM, SMALL }
var ContainerScene = ResourceLoader.load("res://scenes/container.tscn")

@export var size = ShipSize.MEDIUM
@export var node_color:Constants.NodeColor = Constants.NodeColor.RED
@export var spawn_delay: float = 0

@onready var game_manager = %GameManager
@onready var spawn_timer = $SpawnTimer
@onready var timer = $Timer




var spawn = false
var speed = 200
var rotation_speed = 15
var path = []
var path_index = 0
var is_entered_dock = false
var is_dead = false
var path_draw_count = 0;
var score_points = 20;


func _ready():
	if spawn_delay == 0:
		spawn = true
	else:
		spawn_timer.wait_time = spawn_delay
		spawn_timer.start();

	match size:
		ShipSize.LARGE:
			speed = 100
			$AnimatedSprite2D.animation = 'move_large'
			add_container(ContainerScene, 0)
			add_container(ContainerScene, 1)
			add_container(ContainerScene, 2)
		ShipSize.MEDIUM:
			speed = 200
			$AnimatedSprite2D.animation = 'move_medium'
			add_container(ContainerScene, 0)
			add_container(ContainerScene, 1)

func add_container(scene, index):
	var instance = scene.instantiate()
	instance.node_color=node_color
	instance.position = Vector2(0, -4 + index*18)
	$ContainersGoHere.add_child(instance)

func remove_container():
	var count = $ContainersGoHere.get_child_count()
	if count > 0:
		$ContainersGoHere.get_children().pop_back().queue_free()
		return count - 1
	return null

func _process(delta):
	if !spawn:
		return
			
	if path.size() > 0 and path_index < path.size():
		follow_path(delta)

	# JUST STOP
	elif path_index >= path.size():
		clearPath()

	if path.size() == 0 && !is_entered_dock:
		var forward_direction = Vector2(cos(rotation - PI / 2), sin(rotation - PI / 2))
		position += forward_direction * speed * delta

func clearPath():
	path.clear()
	path_index = 0

func follow_path(delta):
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
	path_draw_count+=1
	if path_draw_count >= 3 && score_points > 5:
		score_points-=5
	
	var closest_index = find_closest_point_index(new_path)
	path = new_path
	path_index = closest_index

func unloadingDone():
	rotation = rotation-PI

func repositionInDock(dock):
	clearPath()
	position = dock.position
	rotation = dock.rotation

func unloadContainer():
	timer.one_shot = true
	timer.start(1)

func destroy():
	# Apply penalty to the score
	print('destroyed')
	game_manager.remove_points(20)
	
	$AnimatedSprite2D.animation = 'explode'
	$AnimatedSprite2D.play()
	$ContainersGoHere.hide()
	is_dead = true

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
func _on_body_entered(_body):
	destroy()

func _on_area_entered(area):
	if area.is_in_group('docks'):
		print('Entered the dock')

		is_entered_dock = true
		repositionInDock(area)

		if node_color == area.node_color:
			unloadContainer()
		else:
			print('Wrong color')
			unloadingDone()

	if area.is_in_group('ships'):
		destroy()

func _on_area_exited(area):
	if area.is_in_group('docks'):
		is_entered_dock = false

		print('Left the dock')

func _on_spawn_timer_timeout():
	spawn = true

func _on_timer_timeout():
	var count = remove_container();
	
	if count != null:
		game_manager.add_points(score_points)
		
		if count > 0:
			unloadContainer()
			return;
	
	unloadingDone()
				

func _on_animated_sprite_2d_animation_finished():
	print("IS DEAD? " + str(is_dead))
	if is_dead:
		queue_free()
