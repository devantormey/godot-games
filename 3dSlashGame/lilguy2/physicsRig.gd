extends Node3D

@export var sword_scene: PackedScene  # The sword scene to instance
@export var hand_bone_name: String = "mixamorig_RightForeArm"  # The name of the hand bone in the ragdoll skeleton
@export var sword_joint: Generic6DOFJoint3D  # Reference to the joint used to attach the sword

var ragdoll_skeleton: Skeleton3D
var sword: RigidBody3D
var hand_offset: Vector3
var equip = false;

func _ready():
	# Reference the ragdoll skeleton
	if equip:
		ragdoll_skeleton = $Skeleton3D  # Adjust the path to your ragdoll skeleton node
		hand_offset = Vector3.ZERO
		hand_offset.y = -.3;
		
		# Instance the sword and add it to the scene
		sword = sword_scene.instantiate() as RigidBody3D
		
		add_child(sword)
		
		# Get the hand bone transform
		var hand_bone_id = ragdoll_skeleton.find_bone(hand_bone_name)
		var hand_transform = ragdoll_skeleton.get_bone_global_pose(hand_bone_id)
		
		# Set the sword's initial transform to match the hand bone's transform
		sword.global_transform = hand_transform
		
		# Create and configure the joint
		sword_joint = Generic6DOFJoint3D.new()
		sword_joint.node_a = "physicsRig/Skeleton3D/Physical Bone mixamorig_RightForeArm"
		sword_joint.node_b = sword.get_path()
		
		
		
		
		# Add the joint to the scene
		add_child(sword_joint)

# Optionally, update the joint properties or sword transform in _process or _physics_process
func _physics_process(delta):
	if equip:
		# Ensure the sword follows the hand bone's position
		var hand_bone_id = ragdoll_skeleton.find_bone(hand_bone_name)
		var hand_transform = ragdoll_skeleton.get_bone_global_pose(hand_bone_id)
		
		# Get the base transform of the character
		var base_transform = ragdoll_skeleton.global_transform
		
		# Combine the base transform and the hand bone's local transform
		var combined_transform = base_transform * hand_transform
		
		# Manually apply the hand offset
		combined_transform.origin += hand_transform.basis * hand_offset
		
		# Set the sword's position and rotation to match the combined transform
		sword.global_transform = combined_transform
