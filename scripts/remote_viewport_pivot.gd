extends Control

@onready var base_position = position;

var _grid_size = Vector2(28,28)

@export var path_piece_prefab: PackedScene


func reset():
	position = base_position
	for child in get_children():
		child.queue_free()

