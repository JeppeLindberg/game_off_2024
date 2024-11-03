extends Node3D

@onready var rand_speed = RandomNumberGenerator.new().randf_range(1.5, 2.5)


func _physics_process(delta: float) -> void:
	rotate(Vector3.FORWARD, delta * rand_speed)
