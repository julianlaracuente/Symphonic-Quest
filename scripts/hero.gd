extends CharacterBody3D
class_name Hero

@export var max_health : int = 100
@export var health : int = self.max_health
@export var damage : int = 50
@export var defense :int = 50
@export var atb_time :float = 8
@onready var atb_timer : Timer = $ATBTimer
@export var LIMIT : int

var can_attack = true

func _ready() -> void:
	atb_timer.wait_time = atb_time
	atb_timer.stop()

func take_damage(amount : int):
	health -= max(amount-defense, 0)
	health = max(health, 0)

func is_alive():
	return health > 0

func perfom_attack(target : CharacterBody3D):
	target.take_damage(damage)
	
func play_animation(animation : String):
	if $AnimationPlayer.has_animation(animation):
		$AnimationPlayer.play(animation)
		await $AnimationPlayer.animation_finished

func attack():
	if can_attack:
		play_animation("attack")
		can_attack = false
		$ATBTimer.start()
		print(name, ' : attack')

func gain_health(amount):
	if amount < max_health:
		health+= amount

func _on_timer_timeout() -> void:
	can_attack = true

func _process(delta: float) -> void:
	pass

func get_atb_percent():
	if atb_timer.is_stopped():
		return 1.0
	return 1.0 - (atb_timer.time_left / atb_timer.wait_time)

func consume_item(item : Item):
	if item.health_gain > 0:
		gain_health(item.health_gain)
	else:
		#for now
		pass
