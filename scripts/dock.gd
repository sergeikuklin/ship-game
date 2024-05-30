extends Area2D

@export var node_color:Constants.NodeColor = Constants.NodeColor.RED

@onready var color_tile = $ColorTile

@onready var container = $Container


func _ready():
	color_tile.material.set_shader_parameter('nodeColor', node_color)





