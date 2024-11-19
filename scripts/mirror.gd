extends Node3D

@export var dummy_cam:Node3D
@export var mirror_cam:Node3D
@export var player_cam: Node3D

func _ready() -> void:
	dummy_cam.top_level = false

func _process(_delta: float) -> void:
	scale.z *= -1
	dummy_cam.global_transform = player_cam.global_transform
	scale.z *= -1
	mirror_cam.global_transform = dummy_cam.global_transform
	mirror_cam.global_transform.basis.x *= -1