class_name WinScreen
extends Control

@onready var choice_screen: Control = $ChoiceScreen
@onready var choice_a_button: Button = %ChoiceAButton
@onready var choice_b_button: Button = %ChoiceBButton
@onready var choice_label: Label = %ChoiceText

@onready var stairs_screen: Control = $StairsScreen
@onready var stairs_label: Label = %StairsText

@onready var good_ending_screen: Control = $GoodEndingScreen
@onready var good_ending_label: Label = %GoodEndingText

@onready var bad_ending_screen: Control = $BadEndingScreen
@onready var bad_ending_label: Label = %BadEndingText

enum State {
	CHOICE_SCREEN,
	STAIRS_SCREEN,
	GOOD_ENDING_SCREEN,
	BAD_ENDING_SCREEN
}

var current_state := State.CHOICE_SCREEN

var is_typing := false
var is_skipping := false

const CHOICE_TEXT := "Blinding light emanates from the door.\n\nBut this brightness... it's too much.\n\nIt burns your eyes the longer you're in its presence and it feels as though it will burn your entire body soon enough."
const STAIRS_TEXT := "A hesitant thought lingers in the back of your mind. Is this really what you were waiting for your entire life?\n\nWhat if the world outside isn't as kind as the chipped walls of the castle?\n\nWhat if it isn't as welcoming as those nameless guards. What if you'd rather go back?\n\nOnly one way to find out.\n\nAnd that way... is up."
const GOOD_ENDING_TEXT := "Every step you take, the chains of your past holding you down becomes a distant song.\n\nYou are no longer a princess imprisoned in a twisted castle.\n\nYou are free."
const BAD_ENDING_TEXT := "The light is too much. Too unfamiliar.\n\nYou turn away, and the stairs welcome you back down, into the guarded rooms you know.\n\nSome doors are easier left closed."


func _ready() -> void:
	choice_screen.show()
	stairs_screen.hide()
	good_ending_screen.hide()
	bad_ending_screen.hide()
	current_state = State.CHOICE_SCREEN

	choice_a_button.pressed.connect(_on_bad_choice)
	choice_b_button.pressed.connect(_on_good_choice)

	choice_a_button.visible = false
	choice_b_button.visible = false

	is_typing = true
	is_skipping = false
	await Typewriter.run(
		choice_label,
		CHOICE_TEXT,
		get_tree(),
		func(): return is_skipping
	)
	is_typing = false

	choice_a_button.visible = true
	choice_b_button.visible = true


func _on_good_choice() -> void:
	_show_ending(
		State.STAIRS_SCREEN,
		stairs_screen,
		stairs_label,
		STAIRS_TEXT
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
	await SceneTransition.fade_out()

	current_state = state
	choice_screen.hide()
	screen.show()

	await SceneTransition.fade_in()

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
	var is_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	var is_accept = event.is_action_pressed("ui_accept")

	if not (is_click or is_accept):
		return

	if is_typing:
		is_skipping = true
		return

	if current_state == State.STAIRS_SCREEN:
		_show_ending(
			State.GOOD_ENDING_SCREEN,
			good_ending_screen,
			good_ending_label,
			GOOD_ENDING_TEXT
		)
		return

	if current_state == State.CHOICE_SCREEN:
		return

	_return_to_menu()


func _return_to_menu() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	SceneTransition.change_scene("res://scenes/views/MainMenu.tscn")
