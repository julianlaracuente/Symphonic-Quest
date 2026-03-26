extends Node
"""
if someone, including the boss, is atacking,
this variable will be false, the heroes/boss can attack ONLY
if this flag is true.
"""
var flag = true
var last_flag = flag

var entities: Array[Node3D] = []
var attack_queue: Array[int] = []
@onready var julian: CharacterBody3D = $Julian
@onready var fabian: CharacterBody3D = $Fabian
@onready var yadriel: CharacterBody3D = $Yadriel
@onready var boss: Boss = $Boss

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	entities.append(julian)
	entities.append(fabian)
	entities.append(yadriel)
	entities.append(boss)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if last_flag != flag:
		last_flag = flag
		print("Flag change: " + str(flag))
	if not attack_queue.is_empty() and flag:
		flag = false
		entities[attack_queue[0]].attack()
		if attack_queue[0] != 3:
			boss.take_damage(entities[attack_queue[0]].damage)
		attack_queue.remove_at(0)
