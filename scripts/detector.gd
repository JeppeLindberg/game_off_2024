extends Node3D

var _upright: Basis

func _ready() -> void:
	_upright = transform.basis

func accept():
	position += -transform.basis.z
	var node = get_beam_node(global_position + Vector3.UP, global_position + Vector3.DOWN)
	print(node)

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
