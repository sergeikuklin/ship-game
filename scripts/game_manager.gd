extends Node
var score = 0
@onready var score_label = $ScoreLabel
@onready var level_label = $LevelLabel

var user_name = ''

func add_points(point):
	print('Add ' + str(point) + ' points')
	score += point
	
	score_label.text = 'Score: ' + str(score)
	
func change_level(level):
	level_label.text = 'Level: ' + str(level)
	
func remove_points(point):
	print('Remove ' + str(point) + ' points')
	score -= point
	
	score_label.text = 'Score: ' + str(score)


# Function to initiate the API call.
func get_scores():
	var url = "https://ship-game-3.onrender.com/score"
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request_completed.connect(_on_get_request_completed)
	$HTTPRequest.request(url)

# This method is called when the HTTPRequest node completes the request.
func _on_get_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var json = JSON.new()
		var error = json.parse(body.get_string_from_utf8())
		if error != OK:
			print("Failed to parse JSON: ", error)
			return

		var response = json.get_data()
		handle_scores(response)
	else:
		print("Failed to get scores. HTTP Response Code: ", response_code)

# Handle the scores data as needed.
func handle_scores(scores):
	for score in scores:
		print("Score by %s: %d" % [score.name, score.score])


func post_score():
	var url = "https://ship-game-3.onrender.com/score"
	var unique_id = randi()  # Generate a random integer for ID
	var data = {
		"id": unique_id,
		"name": user_name,
		"score": score
	}
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request_completed.connect(_on_post_request_completed)
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(data))

func _on_post_request_completed(_result, response_code, _headers, body):
	if response_code == 201:
		print("Score posted successfully.", body.get_string_from_utf8())
	else:
		print("Failed to post score. HTTP Response Code: ", response_code )

func handle_game_over():
	print(user_name)
	print('Game over')
	post_score()
