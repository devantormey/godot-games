extends RigidBody3D

var sword_control: Node3D
var camera: Camera3D
var ray_origin: Vector3
var ray_target: Vector3
var mouse_position: Vector2
var attacking = false

var max_speed = 10.0
var acceleration = 5.0
var deceleration = 10.0
var max_angular_speed = 3.0  # Maximum angular speed in radians per second
var rotation_acceleration = 10.0  # How quickly the player turns towards the mouse

func _ready():
	sword_control = $swordControl
	camera = get_parent().get_node("Camera3D")

	if camera == null:
		print("Camera3D not found. Please check the node path.")
	if sword_control == null:
		print("swordControl not found. Please check the node path.")
	
	# Set a high angular damping to stabilize rotation
	angular_damp = 10.0

func _integrate_forces(state):
	handle_movement(state)
	face_mouse(state)

	if Input.is_action_just_pressed("primary"):  # Detect left mouse button press
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
			sword_control.swingSword(pos)

func handle_movement(state):
	var input_vector = Vector3()

	if Input.is_action_pressed("right"):
		input_vector.x += 1
	if Input.is_action_pressed("left"):
		input_vector.x -= 1
	if Input.is_action_pressed("up"):
		input_vector.z -= 1
	if Input.is_action_pressed("down"):
		input_vector.z += 1

	input_vector = input_vector.normalized()

	if input_vector != Vector3():
		var target_velocity = input_vector * max_speed
		var current_velocity = state.linear_velocity
		var impulse = (target_velocity - current_velocity) * acceleration * state.step
		apply_central_impulse(impulse)
	else:
		var current_velocity = state.linear_velocity
		var damping_force = -current_velocity * deceleration * state.step
		apply_central_impulse(damping_force)

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
		
		print("Current Direction:", current_direction)
		print("Target Direction:", target_direction)
		print("Angle to Target:", angle_to_target)
		print("Cross Product:", cross_product)
		
		# Clamp the angle to the maximum angular speed
		var clamped_angle = clamp(angle_to_target, 0, max_angular_speed * state.step)
		var applied_angle = clamped_angle * angle_sign
		
		print("Clamped Angle:", clamped_angle)
		print("Applied Angle:", applied_angle)
		
		# Apply torque to rotate
		if abs(angle_to_target) > 0.01:
			var torque = Vector3(0, applied_angle, 0) * rotation_acceleration
			apply_torque_impulse(torque)
			print("Applying Torque:", torque)
		else:
			print("No significant angle to correct")

	# Constrain the rotation to keep the player upright
	var angular_velocity = state.angular_velocity
	angular_velocity.x = 0
	angular_velocity.z = 0
	state.angular_velocity = angular_velocity

# Smooth camera follow (optional)
func _process(delta):
	if camera:
		var target_position = global_transform.origin
		camera.global_transform.origin = lerp(camera.global_transform.origin, target_position + Vector3(0, 10, 10), 0.1)
		camera.look_at(global_transform.origin, Vector3.UP)
