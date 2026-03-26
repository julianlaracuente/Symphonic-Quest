extends Node
"""
if someone, including the boss, is atacking,
this variable will be false, the heroes/boss can attack ONLY
if this flag is true.
"""
var flag = true
@onready var theme_intro: AudioStreamPlayer = $ThemeIntro
@onready var theme_loop: AudioStreamPlayer = $ThemeLoop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	theme_intro.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_theme_intro_finished() -> void:
	theme_loop.play()
