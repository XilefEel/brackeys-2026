class_name WinScreen
extends Control

@onready var choice_screen: Control = $ChoiceScreen
@onready var choice_a_button: Button = %ChoiceAButton
@onready var choice_b_button: Button = %ChoiceBButton
@onready var choice_label: Label = %ChoiceText

@onready var good_ending_screen: Control = $GoodEndingScreen
@onready var good_ending_label: Label = %GoodEndingText

@onready var bad_ending_screen: Control = $BadEndingScreen
@onready var bad_ending_label: Label = %BadEndingText

enum State {
	CHOICE_SCREEN,
	GOOD_ENDING_SCREEN,
	BAD_ENDING_SCREEN
}

var current_state := State.CHOICE_SCREEN

var is_typing := false
var is_skipping := false

const CHOICE_TEXT := "The stairs seem to go on forever, each step heavier than the last.\n\nThen, finally, a door.\n\nLight spills from beneath it, blinding and warm, unlike anything you've felt in this place."
const GOOD_ENDING_TEXT := "You push the door open.\n\nLight floods over you, swallowing the stairs, the walls, the weight you've carried this whole way.\n\nFor the first time, there is nothing left to fear.\n\nYou are free."
const BAD_ENDING_TEXT := "Your hand falls from the handle.\n\nThe light is too much. Too unfamiliar.\n\nYou turn, and the stairs welcome you back down, into the rooms you know.\n\nSome doors are easier left closed."


func _ready() -> void:
	choice_screen.show()
	good_ending_screen.hide()
	bad_ending_screen.hide()
	current_state = State.CHOICE_SCREEN

	choice_a_button.pressed.connect(_on_bad_choice)
	choice_b_button.pressed.connect(_on_good_choice)

	is_typing = true
	is_skipping = false
	await Typewriter.run(
		choice_label,
		CHOICE_TEXT,
		get_tree(),
		func(): return is_skipping
	)
	is_typing = false


func _on_good_choice() -> void:
	_show_ending(
		State.GOOD_ENDING_SCREEN,
		good_ending_screen,
		good_ending_label,
		GOOD_ENDING_TEXT
	)


func _on_bad_choice() -> void:
	_show_ending(
		State.BAD_ENDING_SCREEN,
		bad_ending_screen,
		bad_ending_label,
		BAD_ENDING_TEXT
	)


func _show_ending(state: State, screen: Control, label: Label, text: String) -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	current_state = state
	choice_screen.hide()
	screen.show()

	is_typing = true
	is_skipping = false
	await Typewriter.run(
		label,
		text,
		get_tree(),
		func(): return is_skipping
	)
	is_typing = false


func _input(event: InputEvent) -> void:
	if current_state == State.CHOICE_SCREEN:
		return

	var is_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	var is_accept = event.is_action_pressed("ui_accept")

	if not (is_click or is_accept):
		return

	if is_typing:
		is_skipping = true
		return

	_return_to_menu()


func _return_to_menu() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	SceneTransition.change_scene("res://scenes/views/MainMenu.tscn")
