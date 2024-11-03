extends Node3D

var target_rotation = 0;
var _upright: Basis
var _target_basis: Basis
var target_spin_rotation = 0

func _ready() -> void:
	_upright = transform.basis


func _physics_process(delta: float) -> void:
	target_rotation = fmod(target_rotation, 360)
	if target_rotation < 0:
		target_rotation += 360
		
	_target_basis = _upright.rotated(Vector3.UP, deg_to_rad(target_spin_rotation)).rotated(Vector3.FORWARD, deg_to_rad(target_rotation))

	transform.basis = transform.basis.slerp(_target_basis, delta * 10)

func spin():
	target_spin_rotation += 360.0/3.0

