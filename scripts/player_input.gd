extends Node

@export var party : Array[Control] = []
@export var options : Array[Label] = []
@onready var arrow_sprite = $Sprite

var current_ui_index : int = 0
var current_option_index : int = 0
var current_hero_ui : Control
var current_option : Label

var in_selection = true
var in_options = false

signal make_visible

func _ready() -> void:
	current_hero_ui = party[current_ui_index]
	update_selection()

func _process(delta):
	input_manager()
			
func input_manager():
	if in_selection:
		if Input.is_action_just_pressed("down"):
			current_ui_index = (current_ui_index + 1) % party.size()
			update_selection()
			
		if Input.is_action_just_pressed("up"):
			current_ui_index = (current_ui_index - 1 + party.size()) % party.size()
			update_selection()
		if Input.is_action_just_pressed("enter"):
			if current_hero_ui.hero.is_alive():
				in_options = true
				in_selection = false
				make_visible.emit()
				update_options()
	elif in_options:
		if Input.is_action_just_pressed("enter"):
			in_options = false
			in_selection = true
			make_visible.emit()
			current_hero_ui.hero.attack()
			update_selection()
		elif Input.is_action_just_pressed("escape"):
			in_options = false
			in_selection = true
			make_visible.emit()
			update_selection()


			
func update_selection():
	current_hero_ui = party[current_ui_index]
	if arrow_sprite:
		arrow_sprite.global_position = current_hero_ui.global_position + Vector2(-35, 2)
	print("currently selecting: ", current_hero_ui.name)

func update_options():
	current_option = options[0]
	if arrow_sprite:
		arrow_sprite.global_position = current_option.global_position + Vector2(-60, 20)
	print("currently selecting: ", current_option.text)

func options_manager():
	if current_option.text == "Attack":
		current_hero_ui.hero.attack()
	else:
		#for now
		pass
		
	
