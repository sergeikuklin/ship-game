extends Area2D

@export var nodeColor:Constants.NodeColor = Constants.NodeColor.RED

@onready var colorTile = $ColorTile


func _ready():
	colorTile.material.set_shader_parameter('nodeColor', nodeColor)	
		
		




