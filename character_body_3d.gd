extends CharacterBody3D
#Imports
@onready var character_model_container = $character_container
@onready var camera_arm = $CameraArm

#Camera settings
@export_subgroup("camera settings")
@export var mouse_sensitivity = 0.004 

#Character settings
@export_subgroup("character settings")
@export var rotation_speed = 10.0
@export var gravity = 20 
@export var speed = 6.0  
@export var jump_force = 10
var character_direction = Vector3.ZERO

func _ready():
	#When the game loads, capture the mouse.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	velocity.y += -gravity * delta
	
	if character_direction != Vector3.ZERO:
		_character_model_rotation(delta)

	if position.y < -10:
		_handle_offscreen()

	move_and_slide()

func _move_player(event):
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_direction = transform.basis * Vector3(input.x, 0, input.y)
	var sync_to_camera_direction = movement_direction.rotated(Vector3.UP, camera_arm.rotation.y)
	character_direction = sync_to_camera_direction
	velocity.x = character_direction.x * speed
	velocity.z = character_direction.z * speed
	
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		
func _character_model_rotation(delta):
	var target_position =  character_direction
	#Basically we rotate in the local axis the container of the model, not the kinematicbody
	var new_transform = character_model_container.transform.looking_at(target_position, Vector3.UP)
	character_model_container.transform  = character_model_container.transform.interpolate_with(new_transform, 15 * delta)

func _camera_rotation(event):
	camera_arm.rotation.x -= event.relative.y * mouse_sensitivity
	camera_arm.rotation_degrees.x = clamp(camera_arm.rotation_degrees.x, -90.0, 30.0)
	camera_arm.rotation.y -= event.relative.x * mouse_sensitivity 

func _handle_offscreen():
	get_tree().reload_current_scene()

func _unhandled_input(event):
	#Pass the inputs to the player
	_move_player(event)

	#If the mouse is captured and is moving, set the camera rotation
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_camera_rotation(event)
	
	#Set free and recapture the mouse if clicked
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
