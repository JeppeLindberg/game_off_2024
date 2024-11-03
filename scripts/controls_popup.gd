extends Area3D

@export var popup_text = '[Press E] Bring up artifact\n[Left click] Activate\n[Press E] Accept solution'


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('interactable')

func interact():
	return(true)

func get_interactable_popup():
	return(popup_text)