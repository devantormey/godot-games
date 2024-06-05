extends Node3D

var player: CharacterBody3D
var body: MeshInstance3D
var hand: Marker3D
var equipped_weapon: RigidBody3D
var joint: Generic6DOFJoint3D

func _ready():
	print("ready")
	#player = get_parent() as CharacterBody3D
	#body = player.find_child("Body") as MeshInstance3D
	#hand = player.find_child("Hand") as Marker3D
	#equipped_weapon = player.find_child("sword") as RigidBody3D
	#joint = player.find_child("Joint") as Generic6DOFJoint3D
	#
	#print(player)
	#print(body)
	#print(hand)
	#print(equipped_weapon)
	#print(joint)
	#
	#setup_joint()

func setup_joint():
	print("setup")
	##joint.node_a = player.get_path()
	##joint.node_b = equipped_weapon.get_path()
	#
	## Set linear limits (translation) - allowing more freedom
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, -0.5)
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, 0.5)
	#
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, -0.5)
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, 0.5)
	#
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, -0.5)
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, 0.5)
	#
	## Set angular limits (rotation) - allowing more freedom
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_LOWER_LIMIT, -45.0)
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_UPPER_LIMIT, 45.0)
	#
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_LOWER_LIMIT, -45.0)
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_UPPER_LIMIT, 45.0)
	#
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_LOWER_LIMIT, -45.0)
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_UPPER_LIMIT, 45.0)
	#
	## Add spring and damping to create a more "floppy" feel
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, 5.0)
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_DAMPING, 0.5)
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_EQUILIBRIUM_POINT, 0.0)
	#
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, 5.0)
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_DAMPING, 0.5)
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_EQUILIBRIUM_POINT, 0.0)
	#
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, 5.0)
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_DAMPING, 0.5)
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_EQUILIBRIUM_POINT, 0.0)
	#
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 5.0)
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.5)
	#joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)
	#
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 5.0)
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.5)
	#joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)
	#
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_STIFFNESS, 5.0)
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 0.5)
	#joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT, 0.0)

func swingSword(target_position: Vector3) -> void:
	print("swing")
	#if equipped_weapon:
		#var hand_position = hand.global_transform.origin
		#var direction = (target_position - hand_position).normalized()
#
		## Maintain the 45 degrees rotation along the Z-axis
		#var base_rotation = Vector3(0, 0, 45)
#
		## Start anticipation (bringing the sword back)
		#var start_rotation = equipped_weapon.rotation_degrees
		#var anticipation_rotation = start_rotation + Vector3(0, -60, 0)  # Bringing the sword back further
#
		## End of swing
		#var end_rotation = start_rotation + Vector3(0, 90, 0)  # Ending angle
#
		## Ready position (neutral position)
		#var ready_rotation = start_rotation
#
		## Durations
		#var anticipation_duration = 0.1
		#var swing_duration = 0.08
		#var return_duration = 0.1
#
		## Animate the anticipation phase
		#var t = 0.0
		#while t < anticipation_duration:
			#t += get_process_delta_time()
			#var interp = t / anticipation_duration
			#equipped_weapon.rotation_degrees = lerp(start_rotation, anticipation_rotation, interp) + base_rotation
			#await get_tree().create_timer(0.01).timeout
		#
		## Reset t for the swing phase
		#t = 0.0
		#var current_rotation = equipped_weapon.rotation_degrees
#
		## Animate the swing phase
		#while t < swing_duration:
			#t += get_process_delta_time()
			#var interp = t / swing_duration
			#equipped_weapon.rotation_degrees = lerp(current_rotation, end_rotation, interp) + base_rotation
			#await get_tree().create_timer(0.01).timeout
#
		## Reset t for the return phase
		#t = 0.0
		#current_rotation = equipped_weapon.rotation_degrees
#
		## Animate the return to ready position phase
		#while t < return_duration:
			#t += get_process_delta_time()
			#var interp = t / return_duration
			#equipped_weapon.rotation_degrees = lerp(current_rotation, ready_rotation, interp) + base_rotation
			#await get_tree().create_timer(0.01).timeout
		#
		## Reset to ready position
		#equipped_weapon.rotation_degrees = ready_rotation + base_rotation
