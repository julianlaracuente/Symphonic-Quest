extends Node

@export var  heroes : Array[Hero] = []
@onready var theme_intro: AudioStreamPlayer = $ThemeIntro
@onready var theme_loop: AudioStreamPlayer = $ThemeLoop
@onready var theme_outro: AudioStreamPlayer = $ThemeOutro

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
	Global.has_won = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	theme_intro.play()
func check_boss():
	if not $Boss.is_alive():
		game_over = true
		Global.has_won = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	all_heroes_dead()
	check_boss()
	
	if game_over and not changing_scene:
		changing_scene = true 
		
		$EndScreenTransition.start()
		print("Timer started, waiting...")
		var tween = create_tween()
		tween.tween_property(theme_loop,"volume_db", -50, 2.0)
		
		await $EndScreenTransition.timeout
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
		theme_loop.stop()
		theme_outro.play()

func _on_theme_intro_finished() -> void:
	theme_loop.play()
