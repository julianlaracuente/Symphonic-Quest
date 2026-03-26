extends Node3D
class_name Boss

@export var max_health : int = 1000
@export var health : int = self.max_health
@export var damage : int = 50
@export var defense :int = 50
@export var atb_time :float = 8
@onready var atb_timer : Timer = $ATBTimer
@onready var model: AnimationPlayer = $AnimationPlayer


# Attack1 (slash) and attack2 (bite)
var attacks: Array[String] = ["Armature_009|Armature_011|mixamo_com|Layer0","Armature_009|Armature|mixamo_com|Layer0"]


var can_attack = true
var can_act = true
var can_take_damage = true

func _ready() -> void:
	atb_timer.wait_time = atb_time
	atb_timer.stop()

func take_damage(amount : int):
	if can_take_damage:
		can_take_damage = false
		health -= max(amount-defense, 0)
		health = max(health, 0)
		if health > 0:
			play_animation("Armature_009|Armature_002|mixamo_com|Layer0")
		else:
			death()

func death():
	play_animation("Armature_009|Armature_005|mixamo_com|Layer0")
	can_attack = false

func is_alive():
	return health > 0

func perfom_attack(target : CharacterBody3D):
	target.take_damage(damage)
	
func play_animation(animation : String):
	if model.has_animation(animation):
		model.play(animation)
		await model.animation_finished
		can_attack = true
		can_take_damage = true

func attack():
	if can_attack:
		play_animation(attacks[randi_range(0,1)])
		can_attack = false
		atb_timer.start()
		print(name, ' : attack')


func _on_timer_timeout() -> void:
	can_attack = true

func _process(delta: float) -> void:
	pass

func get_atb_percent():
	if atb_timer.is_stopped():
		return 1.0
	return 1.0 - (atb_timer.time_left / atb_timer.wait_time)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
	#debug
		attack()
	if Input.is_action_just_pressed("ui_cancel"):
		take_damage(499)
