extends Node3D


@onready var indicator = get_node('indicator')
@onready var detector = get_node('/root/main/puzzle_viewport_container/puzzle_viewport/puzzles/detector')
@onready var player = get_node('/root/main/world/player')
@onready var main = get_node('/root/main')
@onready var puzzles = get_node('/root/main/world/puzzles')

var active = false


func activate():
	active = true
	detector.detector_set_rotation(indicator.target_rotation)

	var target_puzzle = ''
	var closest_distance = 10000.0
	for child in main.get_children_in_groups(puzzles, ['puzzle_closeness']):
		var distance = child.global_position.distance_to(player.global_position)
		if distance < closest_distance:
			target_puzzle = child.get_parent().name
			closest_distance = distance

	detector.set_puzzle(target_puzzle)

func deactivate():
	active = false
	indicator.target_rotation = 0
	detector.complete()

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
