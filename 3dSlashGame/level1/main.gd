extends Node3D
#
#var ray_origin = Vector3()
#var ray_target = Vector3()
#
#func _physics_process(delta):
		#var mouse_position = get_viewport().get_mouse_position()
		##print("Mouse Position: ", mouse_position)
		#ray_origin = $Camera3D.project_ray_origin(mouse_position)
		##print("Ray Origin: " , ray_origin)
		#ray_target = ray_origin + $Camera3D.project_ray_normal(mouse_position)*2000
		##print("Ray target: " ,ray_target)
		#
		#var space_state = get_world_3d().direct_space_state #this basically grabs the current world state? not really sure on this one
		#var params = PhysicsRayQueryParameters3D.new() #this is a change in godot 4 that effected intersect_ray() it now takes in one argument of this type
		#params.from = ray_origin
		#params.to = ray_target
		#var intersection = space_state.intersect_ray(params)
		#
		#if not intersection.is_empty():
			##print("not empty")
			#var pos = intersection.position
			#var look_at_me = Vector3(pos.x,$player.position.y, pos.z)
			#$player.look_at(look_at_me, Vector3.UP)
			#
		#
