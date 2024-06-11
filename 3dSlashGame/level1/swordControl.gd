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

#func swingSword(target_position: Vector3) -> void:
	#print("swing")
#
	#if equipped_weapon:
		#var hand_position = hand.global_transform.origin
		#var direction = (target_position - hand_position).normalized()
#
		## Start anticipation (bringing the sword back)
		#var anticipation_force = -direction * 20.0  # Adjust the magnitude as needed
		#equipped_weapon.apply_central_impulse(anticipation_force)
		#await get_tree().create_timer(0.1).timeout  # Anticipation duration
#
		## Apply swing force
		#var swing_force = direction * 50.0  # Adjust the magnitude as needed
		#equipped_weapon.apply_central_impulse(swing_force)
		#await get_tree().create_timer(0.08).timeout  # Swing duration
#
		## Apply return to ready position force
		#var ready_position = hand.global_transform.origin + direction * 1.0  # Adjust as needed
		#var return_direction = (ready_position - equipped_weapon.global_transform.origin).normalized()
		#var return_force = return_direction * 20.0  # Adjust the magnitude as needed
		#equipped_weapon.apply_central_impulse(return_force)
		#await get_tree().create_timer(0.1).timeout  # Return duration
#
		## Optionally, add some damping or friction to stop the sword after the swing
		#equipped_weapon.linear_damp = 2.0  # Adjust as needed
		#equipped_weapon.angular_damp = 2.0  # Adjust as needed
#
