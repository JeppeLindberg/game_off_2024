extends Node

var _result

@onready var rand = RandomNumberGenerator.new()
@onready var player = get_node('/root/main/world/player')
@onready var player_spawn = get_node('/root/main/world/player_spawn')
@onready var puzzle_viewport_container = get_node('/root/main/puzzle_viewport_container')

var _curr_secs:float
var _delta_secs:float

@export var debug_mode:bool = false

func _ready():
	if debug_mode:
		player.holding_remote = true
	else:
		player.position = player_spawn.position
		puzzle_viewport_container.visible = false

func _process(_delta: float) -> void:
	var time_elapsed = float(Time.get_ticks_msec()) / 1000.0;
	_delta_secs = time_elapsed - _curr_secs
	_curr_secs = time_elapsed

func curr_secs():
	return _curr_secs;
	
func delta_secs():
	return _delta_secs;

# Get all children of the node that belongs to all of the given groups
func get_children_in_groups(node, groups = []):
	_result = []

	_get_children_in_groups_recursive(node, groups)

	return _result

func _get_children_in_groups_recursive(node, groups):
	for child in node.get_children():
		var add_to_result = true;
		if groups != []:
			for group in groups:
				if not child.is_in_group(group):
					add_to_result = false;
					break
				
		if add_to_result:
			_result.append(child)

		_get_children_in_groups_recursive(child, groups)
