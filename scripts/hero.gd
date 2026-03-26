extends CharacterBody3D
class_name Hero

@export var max_health : int = 100
@export var health : int = self.max_health
@export var damage : int = 50
@export var defense :int = 50
@export var atb_time :float = 8
@onready var atb_timer : Timer = $ATBTimer
@export var LIMIT : int

var atb_complete = true

func _ready() -> void:
	atb_timer.wait_time = atb_time
	atb_timer.stop()
	
func can_attack():
	if get_parent():
		return get_parent().flag

func change_flag(boolean):
	if get_parent():
		get_parent().flag = boolean

func take_damage(amount : int):
	health -= max(amount-defense, 0)
	health = max(health, 0)

func is_alive():
	return health > 0

func perfom_attack(target : CharacterBody3D):
	target.take_damage(damage)

# invalid
func play_animation(animation : String):
	pass

func add_to_queue():
	var num
	if self.name == "Julian":
		num = 0
	if self.name == "Fabian":
		num = 1
	if self.name == "Yadriel":
		num = 2
	if not get_parent().attack_queue.has(num) and atb_complete:
		get_parent().attack_queue.append(num)
		atb_complete = false
	
#invalid
func attack():
	play_animation("attack")
	#can_attack = false
	$ATBTimer.start()
	print(name, ' : attack')


func _on_timer_timeout() -> void:
	#can_attack = true
	change_flag(true)
	atb_complete = true

func _process(delta: float) -> void:
	pass

func get_atb_percent():
	if atb_timer.is_stopped():
		return 1.0
	return 1.0 - (atb_timer.time_left / atb_timer.wait_time)
