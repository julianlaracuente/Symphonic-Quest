extends Control

@onready var arrow_1: Sprite2D = $Text/arrow1
@onready var arrow_2: Sprite2D = $Text/arrow2
@onready var fade: AnimationPlayer = $FadeIn_Out/FadeAnimationPlayer
@onready var start_music: AudioStreamPlayer = $AudioStreamPlayer
@onready var select_fx: AudioStreamPlayer = $SelectFX

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
	arrows.append(arrow_1)
	arrows.append(arrow_2)
	show_arrow(index)
	fade.play("fade_in")
	start_music.volume_db = -50
	start_music.play()
	var tween = create_tween()
	tween.tween_property(start_music,"volume_db", 0, 2.0)


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
			tween.tween_property(start_music,"volume_db", -50, 1.0)
	if switch_scene:
		if index == 0:
			get_tree().change_scene_to_file("res://scenes/battle_manager.tscn")
		elif index == 1:
			get_tree().quit()



func _on_fade_animation_player_animation_finished(anim_name: StringName) -> void:
	if "fade_out" in anim_name:
		switch_scene = true
	fading = false
