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
