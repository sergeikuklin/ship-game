extends Area2D

@export var nodeColor:Constants.NodeColor = Constants.NodeColor.RED

func _ready():
	print('Dock ready')

func _on_body_entered(ship):
	print('Entered the dock')
	
	if nodeColor == ship.nodeColor:
		ship.unload()
	else:
		print('Wrong color')
