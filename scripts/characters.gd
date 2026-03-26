extends Hero

@onready var animations_root : Node3D = $Animations
@onready var anim_player : AnimationPlayer = $Animations/AnimationPlayer

var death_animation_displayed = false

var dict_animations = {
	"idle" : "mixamo_com", 
	"attack" : "mixamo_com_001",
	"hit" : "mixamo_com_002",
	"death" : "mixamo_com_003"
}

func _ready() -> void:
	pass
func play_animation(anim_key: String):
	if not dict_animations.has(anim_key): return
	
	var internal_name = dict_animations[anim_key]
	
	if anim_player.has_animation(internal_name):
		anim_player.play(internal_name)
		await anim_player.animation_finished



func _process(delta: float) -> void:
	if not anim_player.is_playing() and is_alive():
		play_animation("idle")
	elif not is_alive() and not death_animation_displayed:
		play_animation('death')
		death_animation_displayed = true

func take_damage(amount : int):
	health = max(health - amount, 0)	
	play_animation("hit")
