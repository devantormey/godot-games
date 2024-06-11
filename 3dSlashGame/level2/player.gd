extends RigidBody3D

var sword_control: Node3D
var camera: Camera3D
var ray_origin: Vector3
var ray_target: Vector3
var mouse_position: Vector2
var attacking = false

var max_speed = 20.0
var acceleration = 5.0
var deceleration = 10.0
var max_angular_speed = 3.0  # Maximum angular speed in radians per second
var rotation_acceleration = 20.0  # How quickly the player turns towards the mouse
@export var SWINGFORCE = 80.0
@export var WINDUPFORCE = 40
var _sword: RigidBody3D
var joint: Generic6DOFJoint3D

func _ready():
	sword_control = $swordControl
	_sword = $sword
	joint = get_parent().find_child("swordArm") as Generic6DOFJoint3D
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
			swingSword(pos)

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
		
		# Clamp the angle to the maximum angular speed
		var clamped_angle = clamp(angle_to_target, 0, max_angular_speed * state.step)
		var applied_angle = clamped_angle * angle_sign
		
		# Apply torque to rotate
		if abs(angle_to_target) > 0.01:
			var torque = Vector3(0, applied_angle, 0) * rotation_acceleration
			apply_torque_impulse(torque)

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

func swingSword(target_position: Vector3) -> void:
	print("swing")

	if _sword:
		print("sword")
		var sword_position = _sword.global_transform.origin
		var direction = (target_position - sword_position).normalized()

		# Relax the joint during windup
		relaxJointForWindup()

		# Apply rotational force to make the sword tip drop
		#var windup_rotation = Vector3(0, 0, 0) * WINDUPFORCE  # Adjust the magnitude as needed
		#_sword.apply_torque_impulse(windup_rotation)

		# Start anticipation (bringing the sword back)
		print("winding up")
		var anticipation_force = -direction * WINDUPFORCE  # Adjust the magnitude as needed
		_sword.apply_central_impulse(anticipation_force)
		await get_tree().create_timer(0.3).timeout  # Anticipation duration

		# Stiffen the joint for the swing
		#stiffenJoint()
		
		print("swinging")
		# Apply swing force
		var swing_force = -direction * SWINGFORCE  # Adjust the magnitude as needed	
		_sword.apply_torque_impulse(swing_force)
		#_sword.apply_central_impulse(swing_force)
		await get_tree().create_timer(0.2).timeout  # Swing duration

		# Apply return to ready position force
		var ready_position = _sword.global_transform.origin + direction * 1.0  # Adjust as needed
		var return_direction = (ready_position - _sword.global_transform.origin).normalized()
		var return_force = return_direction * 20.0  # Adjust the magnitude as needed
		_sword.apply_central_impulse(return_force)
		await get_tree().create_timer(0.1).timeout  # Return duration

		# Optionally, add some damping or friction to stop the sword after the swing
		_sword.linear_damp = 2.0  # Adjust as needed
		_sword.angular_damp = 2.0  # Adjust as needed


func relaxJointForWindup():
	# Relax the joint more specifically for the windup phase
	joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 0.0001)
	joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.001)
	joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)

	joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 0.0001)
	joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.001)
	joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)

	joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 0.001)
	joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.001)
	joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)


func stiffenJointForSwing():
	# Stiffen the joint during the swing phase
	joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, .01)
	joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.01)
	joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)

	joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 0.01)
	joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.01)
	joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)

	joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 0.001)
	joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.001)
	joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)

func stiffenJoint():
	# Stiffen the joint to the default values
	joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, 0.01)
	joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_DAMPING, 0.01)
	joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_EQUILIBRIUM_POINT, 0.0)

	joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, 0.01)
	joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_DAMPING, 0.01)
	joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_EQUILIBRIUM_POINT, 0.0)

	joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, 0.01)
	joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_DAMPING, 0.01)
	joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_EQUILIBRIUM_POINT, 0.0)

	joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 0.01)
	joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.01)
	joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)

	joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 0.01)
	joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.01)
	joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)

	joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 0.01)
	joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.01)
	joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)
