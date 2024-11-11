extends Node3D

var rand_speed = 2.0
var rand_add = 0.0

@onready var main = get_node('/root/main')

var initialized = false


func _physics_process(delta: float) -> void:
	if not initialized:
		rand_speed = main.rand.randf_range(0.1, 0.3)
		if main.rand.randi() % 2 == 0:
			rand_speed *= -1
		rand_add = main.rand.randf_range(0.0, PI*2.0)
		
		initialized = true;

	rotate(Vector3.FORWARD, delta * rand_speed + rand_add)
	rand_add = 0.0
