extends StaticBody3D

var valid := true;

func _ready() -> void:
    add_to_group('node')

func reset():
    valid = false

func visit():
    valid = true

