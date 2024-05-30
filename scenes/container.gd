extends Node2D

@export var node_color:Constants.NodeColor = Constants.NodeColor.GREEN

func _ready():
	$ContainerSprite.material.set_shader_parameter('nodeColor', node_color)
