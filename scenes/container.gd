extends Node2D

@export var node_color:Constants.NodeColor = Constants.NodeColor.GREEN

func _ready():
	$greenContainer.material.set_shader_parameter('nodeColor', node_color)

#func _process(delta):
	#match node_color:
		#Constants.NodeColor.GREEN:
			#$greenContainer.show()
		#Constants.NodeColor.RED:
			#$redContainer.show()
		#Constants.NodeColor.BLUE:
			#$blueContainer.show()
