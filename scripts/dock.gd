extends Area2D

func _ready():
	print('Dock ready')

func _on_body_entered(ship):
	print('Entered')
	ship.unload()
