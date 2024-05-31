extends Node
var score = 0
@onready var score_label = $ScoreLabel
var user_name = ''

func add_points(point):
	print('Add ' + str(point) + ' points')
	score += point
	
	score_label.text = 'Score: ' + str(score)
	
	
func remove_points(point):
	print('Remove ' + str(point) + ' points')
	score -= point
	
	score_label.text = 'Score: ' + str(score)


# Function to initiate the API call.
func get_scores():
	var url = "https://ship-game-3.onrender.com/score"
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request(url)

# This method is called when the HTTPRequest node completes the request.
func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		# Assuming the response is JSON and contains an array of scores
		var data = JSON.parse_string(body.get_string_from_utf8())
		print("Received data: ", data)
		handle_scores(data)
	else:
		print("Failed to get scores. HTTP Response Code: ", response_code)

# Handle the scores data as needed.
func handle_scores(scores):
	for score in scores:
		print("Score by %s: %d" % [score.name, score.score])

func handle_game_over():
	print(user_name)
	print('Game over')
