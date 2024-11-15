extends Node3D

var _upright: Basis
var _puzzle_camera_offset: Vector3
var valid := true;
var target_puzzle_node;
var _rotation = 0.0
var _rotation_offset = 0.0
var _first_accept = true

@onready var puzzle_camera = get_node('/root/main/puzzle_viewport_container/puzzle_viewport/camera')
@onready var puzzles = get_node('/root/main/world/puzzles')
@onready var main = get_node('/root/main')


func _ready() -> void:
	_upright = transform.basis
	_puzzle_camera_offset = puzzle_camera.global_position - global_position

func set_puzzle(new_target_puzzle):
	print(new_target_puzzle)
	target_puzzle_node = get_node('../' + new_target_puzzle)
	global_position = target_puzzle_node.global_position
	puzzle_camera.global_position = global_position + _puzzle_camera_offset
	_rotation = 0.0
	_rotation_offset = 0.0
	_first_accept = true

	valid = true;
	for child in target_puzzle_node.get_children():
		child.reset();

func accept():
	if _first_accept:
		_rotation_offset = -_rotation;
		_first_accept = false
	transform.basis = _upright.rotated(Vector3.DOWN, deg_to_rad(_rotation + _rotation_offset))

	position += -transform.basis.z
	var node = get_beam_node(global_position + Vector3.UP, global_position + Vector3.DOWN)

	if node != null:
		node.visit()
	else:
		valid = false

	print(node)

func complete():
	if _is_valid():
		for child in main.get_children_in_groups(puzzles, ['puzzle_closeness']):
			if child.get_parent().name == target_puzzle_node.name:
				child.queue_free()

		target_puzzle_node.emit_puzzle_complete()

func _is_valid():
	if not valid:
		return(false)
	
	for child in target_puzzle_node.get_children():
		if child.valid == false:
			return(false)

	return(true)

func detector_set_rotation(new_rotation):		
	_rotation = new_rotation
	transform.basis = _upright.rotated(Vector3.DOWN, deg_to_rad(_rotation + _rotation_offset))

func get_beam_node(position_from, position_to):
	var ray_from = position_from
	var ray_to = position_to
	var space_state = get_world_3d().direct_space_state
	var ray = PhysicsRayQueryParameters3D.new()
	ray.from = ray_from
	ray.to = ray_to
	var collision = space_state.intersect_ray(ray)

	if collision.has('collider'):		
		return collision['collider']

	return null
