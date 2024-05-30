extends Node
var score = 0
@onready var score_label = $ScoreLabel


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
func _on_request_completed(result, response_code, headers, body):
	var body_string = body.get_string_from_utf8()
	print("Raw Response: ", body_string)
	if response_code == 200 and body_string.strip() != "":
		var json = JSON.new()  # Create a new JSON instance
		var data = json.parse(body_string)
		if data.error == OK:
			print("Received data: ", data.result)
			handle_scores(data.result)
		else:
			print("JSON parsing error: ", data.error)
	else:
		print("Failed to get scores or empty response. HTTP Response Code: ", response_code)

# Handle the scores data as needed.
func handle_scores(scores):
	for score in scores:
		print("Score by %s: %d" % [score.name, score.score])
