extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
