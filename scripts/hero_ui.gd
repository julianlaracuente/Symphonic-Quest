extends Control

@export var hero : Hero

func _ready() -> void:
	if hero:
		$Health.text = str(hero.max_health) + " / " + str(hero.health)
		$Name.text = hero.name


func _process(delta: float) -> void:
	if hero:
		$ATB.value = hero.get_atb_percent() 
