extends Node3D

# Movement speed
@export var speed: float = 5.0
var isInput = false;
var isWalking = false;
var camera: Camera3D
var ray_origin: Vector3
var ray_target: Vector3
var mouse_position: Vector2
var max_angular_speed = 3.0  # Maximum angular speed in radians per second
var rotation_acceleration = 20.0  # How quickly the player turns towards the mouse
# Velocity vector
var velocity: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_parent().get_node("Camera3D")
	# Any initialization if needed
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_handle_movement(delta)

# Function to handle player movement
func _handle_movement(delta):
	# Reset velocity
	velocity = Vector3.ZERO
	
	# Check input and update velocity
	if Input.is_action_pressed("up"):
		velocity.z += .1
		isInput = true;
	if Input.is_action_pressed("down"):
		velocity.z -= .1
		isInput = true;
	if Input.is_action_pressed("left"):
		velocity.x += .1
		isInput = true;
	if Input.is_action_pressed("right"):
		velocity.x -= .1
		isInput = true;
	
	if isInput == true:
		isWalking = true;
	else:
		isWalking = false;
		
	isInput = false;
	# Normalize velocity to prevent faster diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	# Update the position of the node
	translate(velocity * delta)

func face_mouse(state):
	mouse_position = get_viewport().get_mouse_position()
	ray_origin = camera.project_ray_origin(mouse_position)
	ray_target = ray_origin + camera.project_ray_normal(mouse_position) * 2000

	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_target
	var intersection = space_state.intersect_ray(params)

	if not intersection.is_empty():
		var pos = intersection.position
		var look_at_me = Vector3(pos.x, global_transform.origin.y, pos.z)
		
		# Calculate the direction to look at
		var target_direction = (look_at_me - global_transform.origin).normalized()
		
		# Calculate the current direction
		var current_direction = -global_transform.basis.z
		
		# Calculate the angle between the directions
		var angle_to_target = current_direction.angle_to(target_direction)
		var cross_product = current_direction.cross(target_direction).y
		
		# Determine the sign of the angle
		var angle_sign = sign(cross_product)
		
		# Clamp the angle to the maximum angular speed
		var clamped_angle = clamp(angle_to_target, 0, max_angular_speed * state.step)
		var applied_angle = clamped_angle * angle_sign
		
		# Apply torque to rotate
		if abs(angle_to_target) > 0.01:
			var torque = Vector3(0, applied_angle, 0) * rotation_acceleration
			#apply_torque_impulse(torque)

	# Constrain the rotation to keep the player upright
	#var angular_velocity = state.angular_velocity
	#angular_velocity.x = 0
	#angular_velocity.z = 0
	#state.angular_velocity = angular_velocity
