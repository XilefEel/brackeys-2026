class_name DialogueUI
extends CanvasLayer

@onready var name_label: Label = %NameLabel
@onready var dialogue_label: Label = %DialogueLabel

var is_typing := false
var is_skipping := false

var current_name: String = ""
var lines: Array[String] = []
var current_index: int = 0


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if not visible:
		return

	var is_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	var is_accept = event.is_action_pressed("ui_accept")

	if not (is_click or is_accept):
		return

	if is_typing:
		is_skipping = true
		return

	current_index += 1
	if current_index < lines.size():
		show_current_line()
	else:
		hide()


func play(character_name: String, dialogue_lines: Array[String]) -> void:
	if dialogue_lines.is_empty():
		return

	current_name = character_name
	lines = dialogue_lines
	current_index = 0

	show()
	show_current_line()


func show_current_line() -> void:
	name_label.text = current_name
	var message = lines[current_index]

	is_typing = true
	is_skipping = false
	await Typewriter.run(
		dialogue_label,
		message,
		get_tree(),
		func(): return is_skipping
	)
	is_typing = false