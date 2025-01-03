extends Area3D

@onready var player = get_node('/root/main/world/player')

signal interacted()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('interactable')

func interact():
	player.holding_remote = true
	interacted.emit()
	queue_free()
	return(true)

func get_interactable_popup():
	return('[Press E] Pick up artifact')