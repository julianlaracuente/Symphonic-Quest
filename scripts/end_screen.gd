extends Control

@onready var arrow_1: Sprite2D = $Text/arrow1
@onready var arrow_2: Sprite2D = $Text/arrow2
@onready var fade: AnimationPlayer = $FadeIn_Out/FadeAnimationPlayer
@onready var lose_theme_start: AudioStreamPlayer = $LoseThemeStart
@onready var lose_theme_loop: AudioStreamPlayer = $LoseThemeLoop
@onready var select_fx: AudioStreamPlayer = $SelectFX
@onready var win_theme_loop: AudioStreamPlayer = $WinThemeLoop
@onready var win_lose_label: Label = $Text/Win_Lose

var music: Array[AudioStreamPlayer] = []
var music_index = 0
var arrows: Array[Sprite2D] = []
var index = 0
var fading = true
var switch_scene = false

func show_arrow(num: int):
	for arrow in arrows:
		arrow.hide()
	arrows[num].show()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.clear()
	arrows.append(arrow_1)
	arrows.append(arrow_2)
	music_index = 0
	if Global.has_won:
		music.append(win_theme_loop)
		win_lose_label.text = "SUCCESS"
	else:
		music.append(lose_theme_start)
		music.append(lose_theme_loop)
		win_lose_label.text = "FAILURE"
	show_arrow(index)
	fade.play("fade_in")
	#music[music_index].volume_db = -50
	music[music_index].play()
	var tween = create_tween()
	tween.tween_property(music[index],"volume_db", 0, 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not fading:
		if Input.is_action_just_pressed("up"):
			index -= 1
			if index < 0:
				index = 1
			show_arrow(index)
		
		if Input.is_action_just_pressed("down"):
			index +=1
			if index > 1:
				index = 0
			show_arrow(index)
			
		if Input.is_action_just_pressed("enter") or Input.is_action_just_pressed("space"):
			select_fx.play()
			fading = true
			fade.play("fade_out")
			var tween = create_tween()
			tween.tween_property(music[music_index],"volume_db", -50, 1.0)
	if switch_scene:
		if index == 0:
			get_tree().change_scene_to_file("res://scenes/battle_manager.tscn")
		elif index == 1:
			get_tree().quit()



func _on_fade_animation_player_animation_finished(anim_name: StringName) -> void:
	if "fade_out" in anim_name:
		switch_scene = true
	fading = false




func _on_lose_theme_start_finished() -> void:
	lose_theme_start.stop()
	lose_theme_loop.play()
	music_index = 1
