#extends Node3D
#
#var animation_player: AnimationPlayer
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#animation_player = $AnimationPlayer
	#animation_player.play("idle")
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#

extends Node3D

var animation_player: AnimationPlayer
var parent_node: Node3D
var top_parent_node: Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = $AnimationPlayer
	animation_player.play("idle")
	parent_node = get_parent() as Node3D
	top_parent_node = get_owner()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent_node:
		# Make sure this node follows the parent's translation and rotation
		global_transform = parent_node.global_transform
		if top_parent_node.isWalking == true:
			animation_player.play("walk", 2.0, 2.0)
		else:
			animation_player.play("idle")
