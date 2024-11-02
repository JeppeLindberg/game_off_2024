extends Node3D


var target_rotation = 0.0;
var _upright: Basis



func _ready() -> void:
	_upright = transform.basis


func open_door():
	var collider: CollisionShape3D = get_node('door/static_body/collider')
	collider.disabled = true;
	target_rotation = 77.0

func _physics_process(delta: float) -> void:
	target_rotation = fmod(target_rotation, 360)
	if target_rotation < 0:
		target_rotation += 360
		
	var _target_basis = _upright.rotated(Vector3.UP, deg_to_rad(target_rotation))

	transform.basis = transform.basis.slerp(_target_basis, delta * 1)
