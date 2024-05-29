extends Area2D

func _ready():
	print('Dock ready')

func _on_body_entered(body):
	print('Entered')
	#body.unload()
