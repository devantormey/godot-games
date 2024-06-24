extends Node3D

var animation_player: AnimationPlayer
var parent_node: Node3D

var is_rotating: bool = false
var rotation_speed: float = 0.01  # Adjust rotation speed as needed
var previous_mouse_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	parent_node = get_parent() as Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_handle_camera_rotation()

func _handle_camera_rotation():
	if Input.is_action_just_pressed("mouse_middle"):
		is_rotating = true
		previous_mouse_position = get_viewport().get_mouse_position()

	if Input.is_action_just_released("mouse_middle"):
		is_rotating = false

	if is_rotating:
		var current_mouse_position = get_viewport().get_mouse_position()
		var mouse_delta = current_mouse_position - previous_mouse_position

		# Calculate the rotation delta
		var rotation_delta_x = mouse_delta.y * rotation_speed
		var rotation_delta_y = -mouse_delta.x * rotation_speed

		# Rotate the camera around the parent node
		#self.rotate_x(rotation_delta_x)
		#self.rotate_y(rotation_delta_y)
		parent_node.rotate_y(rotation_delta_y)

		# Maintain the camera's distance from the parent node
		var distance = (self.global_transform.origin - parent_node.global_transform.origin).length()
		self.global_transform.origin = parent_node.global_transform.origin + self.global_transform.basis.z * distance

		previous_mouse_position = current_mouse_position
