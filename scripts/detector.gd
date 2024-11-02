extends Node3D

var _upright: Basis
var valid := true;
var target_puzzle_node;


func _ready() -> void:
	_upright = transform.basis

func set_puzzle(new_target_puzzle):
	target_puzzle_node = get_node('../' + new_target_puzzle)
	global_position = target_puzzle_node.global_position

	valid = true;
	for child in target_puzzle_node.get_children():
		child.valid = false

func accept():
	position += -transform.basis.z
	var node = get_beam_node(global_position + Vector3.UP, global_position + Vector3.DOWN)

	if node != null:
		node.visit()
	else:
		valid = false

	print(node)

func complete():
	if _is_valid():
		target_puzzle_node.emit_puzzle_complete()

func _is_valid():
	if not valid:
		return(false)
	
	for child in target_puzzle_node.get_children():
		if child.valid == false:
			return(false)

	return(true)

func detector_set_rotation(new_rotation):		
	transform.basis = _upright.rotated(Vector3.DOWN, deg_to_rad(new_rotation))

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
