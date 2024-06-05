extends CharacterBody3D

var sword_control: Node3D
var camera: Camera3D
var ray_origin: Vector3
var ray_target: Vector3
var mouse_position: Vector2
var attacking = false

var max_speed = 10.0
var acceleration = 5.0
var deceleration = 10.0

func _ready():
	sword_control = $swordControl
	camera = get_node("/root/level/Camera3D")

	if camera == null:
		print("Camera3D not found. Please check the node path.")
	if sword_control == null:
		print("swordControl not found. Please check the node path.")

func _process(delta):
	handle_movement(delta)
	face_mouse()

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

func handle_movement(delta):
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

	# Accelerate to max speed
	if input_vector != Vector3():
		velocity.x = lerp(velocity.x, input_vector.x * max_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, input_vector.z * max_speed, acceleration * delta)
	else:
		# Decelerate to a stop
		velocity.x = lerp(velocity.x, 0.0, deceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, deceleration * delta)

	move_and_slide()

func face_mouse():
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
		look_at(look_at_me, Vector3.UP)
