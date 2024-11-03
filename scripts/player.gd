extends CharacterBody3D

@export_subgroup("Properties")
@export var movement_speed = 5
@export var jump_strength = 8

var mouse_sensitivity = 700
var gamepad_sensitivity := 0.075

var mouse_captured := true

var movement_velocity: Vector3
var rotation_target: Vector3

var input_mouse: Vector2

var health:int = 100
var gravity := 0.0

var previously_floored := false

var holding_remote := false;
var remote_active := false;
var remote_active_history := [false, false];
var use_deactivating_position_until := 0.0

var tween:Tween

@onready var camera = get_node('head/camera')
@onready var forward: RayCast3D = get_node('head/camera/forward')
@onready var remote_controller = get_node('head/camera/sub_viewport_container/sub_viewport/camera/remote')
@onready var not_active_point = get_node('head/camera/sub_viewport_container/sub_viewport/camera/not_active_point')
@onready var active_point = get_node('head/camera/sub_viewport_container/sub_viewport/camera/active_point')
@onready var active_point_deactivating = get_node('head/camera/sub_viewport_container/sub_viewport/camera/active_point_deactivating')
@onready var sound_footsteps = get_node('footsteps')
@onready var blaster_cooldown = get_node('cooldown')
@onready var main = get_node('/root/main')
@onready var hud_text = get_node('/root/main/hud/text_container/text')

@export var crosshair:TextureRect

# Functions

func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	
	# Handle functions
	
	handle_controls(delta)
	handle_gravity(delta)
	
	# Movement

	var applied_velocity: Vector3

	if remote_active_history[0]:
		movement_velocity = Vector3.ZERO
	else:
		movement_velocity = transform.basis * movement_velocity # Move forward		
	
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)	
	applied_velocity.y = -gravity
		
	velocity = applied_velocity
	move_and_slide()
	
	# Rotation
	
	camera.rotation.z = lerp_angle(camera.rotation.z, -input_mouse.x * 25 * delta, delta * 5)	
	
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
	
	# Remote

	remote_controller.visible = holding_remote

	if remote_active_history[0] == true and remote_active_history[1] == false:
		remote_controller.activate()
	elif remote_active_history[0] == false and remote_active_history[1] == true:
		if remote_controller.deactivate():
			use_deactivating_position_until = main.curr_secs() + 1.0

	var target_position = Vector3.ZERO;
	if remote_active_history[0]:
		target_position = active_point.position
	else:
		if main.curr_secs() < use_deactivating_position_until:
			target_position = active_point_deactivating.position
		else:
			target_position = not_active_point.position
	remote_controller.position = lerp(remote_controller.position, target_position - (basis.inverse() * applied_velocity / 30), delta * 10)
	
	# Movement sound
	
	sound_footsteps.stream_paused = true
	
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			sound_footsteps.stream_paused = false
	
	# Landing after jump or falling
	
	camera.position.y = lerp(camera.position.y, 0.0, delta * 5)
	
	if is_on_floor() and gravity > 1 and !previously_floored: # Landed
		Audio.play("sounds/land.ogg")
		camera.position.y = -0.1
	
	previously_floored = is_on_floor()
	
	# Falling/respawning
	
	if position.y < -10:
		get_tree().reload_current_scene()

	

# Mouse movement

func _input(event):
	if event is InputEventMouseMotion and mouse_captured:
		
		input_mouse = event.relative / mouse_sensitivity
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity

func handle_controls(_delta):
	
	# Mouse capture
	
	if Input.is_action_just_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_captured = true
	
	if Input.is_action_just_pressed("mouse_capture_exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_captured = false
		
		input_mouse = Vector2.ZERO
	
	# Movement
	
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	movement_velocity = Vector3(input.x, 0, input.y).normalized() * movement_speed
	
	# Rotation
	
	var rotation_input := Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	
	rotation_target -= Vector3(-rotation_input.y, -rotation_input.x, 0).limit_length(1.0) * gamepad_sensitivity
	rotation_target.x = clamp(rotation_target.x, deg_to_rad(-90), deg_to_rad(90))

	# Interact

	var interacted = false
	hud_text.text = '';
	var intractable_node = forward.get_collider()
	if intractable_node != null and intractable_node.is_in_group('interactable'):
		hud_text.text = intractable_node.get_interactable_popup()
		if not holding_remote and Input.is_action_just_pressed("interact"):
			interacted = intractable_node.interact()
	
	# Remote
	
	if holding_remote and not interacted:
		if Input.is_action_just_pressed("toggle_remote"):
			remote_active = !remote_active
		remote_active_history.pop_back()
		remote_active_history.push_front(remote_active)

		if Input.is_action_just_pressed('accept'):
			remote_controller.input_accept()
		if Input.is_action_just_pressed('move_left'):
			remote_controller.input_left()
		if Input.is_action_just_pressed('move_right'):
			remote_controller.input_right()
	

# Handle gravity

func handle_gravity(delta):
	
	gravity += 20 * delta
	
	if gravity > 0 and is_on_floor():
		gravity = 0

