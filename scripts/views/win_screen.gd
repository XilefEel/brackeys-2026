class_name WinScreen
extends Control

@onready var choice_screen: Control = $ChoiceScreen
@onready var choice_a_button: Button = %ChoiceAButton
@onready var choice_b_button: Button = %ChoiceBButton

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

const CHOICE_TEXT := "..."
const GOOD_ENDING_TEXT := "..."
const BAD_ENDING_TEXT := "..."


func _ready() -> void:
	choice_screen.show()
	good_ending_screen.hide()
	bad_ending_screen.hide()
	current_state = State.CHOICE_SCREEN

	choice_a_button.pressed.connect(_on_bad_choice)
	choice_b_button.pressed.connect(_on_good_choice)


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
	await Typewriter.run(label, text, get_tree(), func(): return is_skipping)
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
