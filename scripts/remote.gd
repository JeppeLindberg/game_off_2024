extends Node3D


@onready var indicator = get_node('indicator')
@onready var detector = get_node('/root/main/puzzle_viewport_container/puzzle_viewport/puzzles/detector')
@onready var player = get_node('/root/main/world/player')
@onready var main = get_node('/root/main')
@onready var puzzles = get_node('/root/main/world/puzzles')
@onready var shine_container = get_node('shine_container')

var active = false
var accept_recieved = false
@export var glow_curve: Curve
var glow_start_time = 0.0


func _process(_delta: float) -> void:
	var time_elapsed = main.curr_secs() - glow_start_time
	
	var target_modulate = 0.0
	if 0 < time_elapsed and time_elapsed < 1:
		target_modulate = glow_curve.sample_baked(time_elapsed)
		
	var children = main.get_children_in_groups(shine_container)
	for child in children:
		if child is Sprite3D:
			child.modulate = Color(1, 1, 1, target_modulate)

func activate():
	active = true
	accept_recieved = false
	detector.detector_set_rotation(indicator.target_rotation)

	var target_puzzle = ''
	var closest_distance = 10000.0
	for child in main.get_children_in_groups(puzzles, ['puzzle_closeness']):
		var distance = child.global_position.distance_to(player.global_position)
		if distance < closest_distance:
			target_puzzle = child.get_parent().name
			closest_distance = distance

	if closest_distance < 30:
		detector.set_puzzle(target_puzzle)

func deactivate():
	active = false
	indicator.target_rotation = 0
	if accept_recieved:
		glow_start_time = main.curr_secs()

	detector.complete()

	return (accept_recieved)

func input_accept():
	if not active:
		return

	accept_recieved = true
	indicator.spin()
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
