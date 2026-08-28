class_name GameOver
extends Control

@onready var death_screen: Control = $DeathScreen
@onready var death_label: Label = %DeathText
@onready var amulet_screen: Control = $AmuletScreen
@onready var amulet_label: Label = %AmuletText

enum State {
	DEATH_SCREEN,
	AMULET_SCREEN
}

var current_state := State.DEATH_SCREEN
var is_first_death := false
var is_typing := false
var is_skipping := false

const FIRST_DEATH_TEXT := "You find yourself trapped amidst the castle's walls.\n\nDarkness begins to grow.\n\nIn a desperate attempt to find yourself, you feel a sudden coldness on your palm."
const NORMAL_DEATH_TEXT := "You find yourself trapped amidst the castle's walls.\n\nSomehow, you stumble across a familiar looking room."
const AMULET_TEXT := "A striking, silver amulet.\n\nOne that reveals which hearts are true, and ones who deceive.\n\nHold Q to use the amulet."


func _ready() -> void:
	death_screen.hide()
	amulet_screen.hide()

	is_first_death = not GlobalState.has_died_once
	GlobalState.has_died_once = true

	current_state = State.DEATH_SCREEN
	death_screen.show()
	_show_line(
		death_label,
		FIRST_DEATH_TEXT if is_first_death else NORMAL_DEATH_TEXT
	)


func _input(event: InputEvent) -> void:
	var is_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	var is_accept = event.is_action_pressed("ui_accept")

	if not (is_click or is_accept):
		return

	if is_typing:
		is_skipping = true
		return

	match current_state:
		State.DEATH_SCREEN:
			if is_first_death:
				_go_to_amulet_screen()
			else:
				_return_to_game()
		State.AMULET_SCREEN:
			_return_to_game()


func _go_to_amulet_screen() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	current_state = State.AMULET_SCREEN
	death_screen.hide()
	amulet_screen.show()
	_show_line(amulet_label, AMULET_TEXT)


func _show_line(label: Label, message: String) -> void:
	is_typing = true
	is_skipping = false
	await Typewriter.run(
		label,
		message,
		get_tree(),
		func(): return is_skipping
	)
	is_typing = false


func _return_to_game() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	SceneTransition.change_scene("res://scenes/views/game.tscn")