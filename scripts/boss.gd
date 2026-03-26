extends Node3D
class_name Boss

@export var max_health : int = 150
@export var health : int = self.max_health
@export var damage : int = 50
@export var defense :int = 50
@export var atb_time :float = 8
@onready var atb_timer : Timer = $ATBTimer
@onready var model: AnimationPlayer = $AnimationPlayer


# Attack1 (slash) and attack2 (bite)
var idle = "Armature_009|Armature_010|mixamo_com|Layer0"
var slash = "Armature_009|Armature_011|mixamo_com|Layer0"
var bite = "Armature_009|Armature|mixamo_com|Layer0"
var hurt = "Armature_009|Armature_002|mixamo_com|Layer0"
var dying = "Armature_009|Armature_005|mixamo_com|Layer0"
var attacks: Array[String] = [slash, bite]


var atb_complete = true
var can_act = true
var can_take_damage = true

func _ready() -> void:
	atb_timer.wait_time = atb_time
	atb_timer.stop()
	play_animation(idle)

func can_attack():
	if get_parent():
		return get_parent().flag

func change_flag(boolean):
	if get_parent():
		get_parent().flag = boolean

func can_change_flag():
	for hero in get_parent().heroes:
		if hero.get_atb_percent() < 1:
			return false
	return true

func take_damage(amount : int):
	#if can_take_damage:
	can_take_damage = false
	health = max(health - amount, 0)	
	if health > 0:
		play_animation(hurt)
	else:
		death()

func death():
	play_animation(dying)
	atb_complete = false

func is_alive():
	return health > 0

func perfom_attack(target : CharacterBody3D):
	target.take_damage(damage)
	
func play_animation(animation : String):
	if model.has_animation(animation):
		model.play(animation)
		

func attack():
	if can_attack() and atb_complete:
		change_flag(false)
		var ability_int = randi_range(0,1)
		play_animation(attacks[ability_int])
		atb_complete = false
		atb_timer.start()
		print(name, ' : attack')



func _process(delta: float) -> void:
	if is_alive():
		attack()

	
	
func get_atb_percent():
	if atb_timer.is_stopped():
		return 1.0
	return 1.0 - (atb_timer.time_left / atb_timer.wait_time)



func _on_atb_timer_timeout() -> void:
	atb_complete = true
	print(name + " : ATB Complete")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	change_flag(true)
	if is_alive():
		play_animation(idle)
		print(name + " : Action free")
