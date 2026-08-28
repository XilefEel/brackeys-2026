class_name DialogueUI
extends CanvasLayer

@onready var name_label: Label = %NameLabel
@onready var dialogue_label: Label = %DialogueLabel

var is_typing := false
var is_skipping := false


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

	hide()


func play(character_name: String, message: String) -> void:
	if message.is_empty():
		return

	show()
	_show_line(character_name, message)


func _show_line(character_name: String, message: String) -> void:
	name_label.text = character_name

	is_typing = true
	is_skipping = false
	await Typewriter.run(
		dialogue_label,
		message,
		get_tree(),
		func(): return is_skipping
	)
	is_typing = false