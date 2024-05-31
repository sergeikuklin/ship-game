extends Control

var user_name = ''
# In ScoreScene.gd
#signal game_start

func _on_button_pressed():
	print('start')
	%GameManager.user_name = user_name
	#%GameManager.start_game()
	# When the Start button is pressed and all conditions are met
	#emit_signal("game_start")


func _on_line_edit_text_changed(new_text):
	user_name = new_text
	
