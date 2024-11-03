extends StaticBody3D

var valid := true;
var visits := 0;

func _ready() -> void:
    add_to_group('node')

func reset():
    visits = 0;
    valid = false
    print('reset')

func visit():
    visits += 1
    if visits == 1:
        valid = true
    else:
        valid = false

