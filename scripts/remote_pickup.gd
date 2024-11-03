extends Area3D

@onready var player = get_node('/root/main/world/player')




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('interactable')

func interact():
	player.holding_remote = true
	queue_free()
	return(true)