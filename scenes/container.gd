extends Node2D

@export var node_color:Constants.NodeColor = Constants.NodeColor.GREEN


func _ready():
	match node_color:
		Constants.NodeColor.GREEN:
			$greenContainer.show()
		Constants.NodeColor.RED:
			$redContainer.show()
		Constants.NodeColor.BLUE:
			$blueContainer.show()
