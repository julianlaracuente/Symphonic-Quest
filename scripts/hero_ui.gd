extends Control

@export var hero : Hero

var is_dead_displayed = false

func _ready() -> void:
	if hero:
		$Health.text = str(hero.max_health) + " / " + str(hero.health)
		$Name.text = hero.name


func _process(delta: float) -> void:
	if hero:
		$ATB.value = hero.get_atb_percent()

		if not hero.is_alive() and not is_dead_displayed:
			$Name.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			$Sprite2D.visible = true
			is_dead_displayed = true
