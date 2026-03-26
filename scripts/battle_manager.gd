extends Node

@export var  heroes : Array[Hero] = []

"""
if someone, including the boss, is atacking,
this variable will be false, the heroes/boss can attack ONLY
if this flag is true.
"""
var flag = true
var game_over = false
var changing_scene = false

func all_heroes_dead():
	var anyone_alive = false
	for hero in heroes:
		if hero.is_alive():
			anyone_alive = true
			break 
	game_over = !anyone_alive
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func check_boss():
	if not $Boss.is_alive():
		game_over = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	all_heroes_dead()
	check_boss()
	
	if game_over and not changing_scene:
		changing_scene = true 
		
		$EndScreenTransition.start()
		print("Timer started, waiting...")
		
		await $EndScreenTransition.timeout
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
