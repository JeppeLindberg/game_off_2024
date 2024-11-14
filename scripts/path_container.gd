extends Control

@onready var base_position = position;

var _grid_size = 56.0
var _rotation = 0.0
var _first_accept = true

@export var path_piece_prefab: PackedScene


func _physics_process(delta: float) -> void:	
	position = lerp(position, base_position, delta * 10)

func reset():
	position = base_position
	_first_accept = true
	_rotation = 0.0
	for child in get_children():
		child.queue_free()

func accept():
	var prev_pos = global_position
	position += Vector2.UP.rotated(deg_to_rad(_rotation)) * _grid_size
	var new_pos = global_position

	for child in get_children():
		child.position -= Vector2.UP.rotated(deg_to_rad(_rotation)) * _grid_size

	var spawn_pos
	var new_piece:Control
	if not _first_accept:
		spawn_pos = lerp(prev_pos, new_pos, -0.5)
		new_piece = path_piece_prefab.instantiate()
		add_child(new_piece)
		new_piece.global_position = spawn_pos

		if (new_pos - prev_pos).y == 0:
			new_piece.rotation_degrees = 90

	_first_accept = false

	spawn_pos = lerp(prev_pos, new_pos, 0.5)
	new_piece = path_piece_prefab.instantiate()
	add_child(new_piece)
	new_piece.global_position = spawn_pos

	if (new_pos - prev_pos).y == 0:
		new_piece.rotation_degrees = 90

func path_set_rotation(new_rotation):
	_rotation = new_rotation
