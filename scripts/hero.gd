extends CharacterBody3D
class_name Hero

@export var max_health : int = 100
@export var health : int = self.max_health
@export var damage : int = 50
@export var defense :int = 50

func take_damage(amount : int):
	health = max(amount-defense, 0)
	
func is_alive():
	return health > 0

func perfom_attack(target : CharacterBody3D):
	target.take_damage()

func lol():
	pass
