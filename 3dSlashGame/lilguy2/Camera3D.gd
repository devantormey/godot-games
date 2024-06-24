extends Camera3D

@export var bullet_scene: PackedScene



# Sensitivity settings
@export var mouse_sensitivity: float = 0.2
@export var movement_speed: float = 10.0
@export var acceleration: float = 5.0
@export var deceleration: float = 10.0

# Internal variables
var velocity: Vector3 = Vector3.ZERO
var input_vector: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture the mouse
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_movement(delta)
	if Input.is_action_just_pressed("fire"):
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_length = 100
		var from = project_ray_origin(mouse_pos)
		var to = from + project_ray_normal(mouse_pos) * ray_length
		var bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.look_at(to)
		bullet.top_level = true;
		bullet.fire(10)
		
func handle_movement(delta):
	input_vector = Vector3()

	if Input.is_action_pressed("forward"):
		input_vector.z -= 1
	if Input.is_action_pressed("backward"):
		input_vector.z += 1
	if Input.is_action_pressed("left"):
		input_vector.x -= 1
	if Input.is_action_pressed("right"):
		input_vector.x += 1
	if Input.is_action_pressed("up"):
		input_vector.y += 1
	if Input.is_action_pressed("down"):
		input_vector.y -= 1

	input_vector = input_vector.normalized()

	# Accelerate to max speed
	if input_vector != Vector3():
		velocity = velocity.lerp(input_vector * movement_speed, acceleration * delta)
	else:
	# Decelerate to a stop
		velocity = velocity.lerp(Vector3.ZERO, deceleration * delta)

	translate(velocity * delta)
func _unhandled_input(event):
	pass
	#if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		#var vertical_rotation = deg_to_rad(-event.relative.y * mouse_sensitivity)
		#var new_rotation_x = rotation_degrees.x + vertical_rotation
#
		## Clamp vertical rotation between -90 and 90 degrees
		#if new_rotation_x > -90 and new_rotation_x < 90:
			#rotate_x(vertical_rotation)
	#elif event is InputEventKey:
		#if event.pressed and event.scancode == KEY_ESCAPE:
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Release the mouse
