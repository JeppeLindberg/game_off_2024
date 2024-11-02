extends Node3D


@onready var indicator = get_node('indicator')
@onready var detector = get_node('/root/main/puzzle_viewport_container/puzzle_viewport/camera/puzzles/detector')

var active = false


func activate():
	active = true

func deactivate():
	active = false
	indicator.target_rotation = 0

func input_accept():
	if not active:
		return
	detector.accept()

func input_left():
	if not active:
		return

	indicator.target_rotation -= 90
	detector.detector_set_rotation(indicator.target_rotation)

func input_right():
	if not active:
		return

	indicator.target_rotation += 90
	detector.detector_set_rotation(indicator.target_rotation)
