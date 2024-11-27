extends Node3D

@export var player: Node3D


func _process(delta: float) -> void:
	rotate_y(delta*0.01)
	global_position = player.global_position + Vector3.UP * 42.0
