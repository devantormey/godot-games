extends Node3D


@export var starting_weapon: PackedScene
var hand
var equipped_weapon: Node3D

func _ready():
	hand = get_parent().find_child("Hand")
	print(hand)
	
	#equipWeapon(starting_weapon)
		
	
func equipWeapon(weapon_to_equip):
	if equipped_weapon:
		print("Deleting Equiped weapon")
		equipped_weapon.queue_free()
	
	else:
		print("no Weapon")
		equipped_weapon = weapon_to_equip.instantiate()
		hand.add_child(equipped_weapon)
		print(equipped_weapon)
	
	#equipped_weapon = weapon_to_equip.instantiate()	

	



