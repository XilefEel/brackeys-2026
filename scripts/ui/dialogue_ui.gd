class_name DialogueUI
extends CanvasLayer

@onready var name_label: Label = %NameLabel
@onready var dialogue_label: Label = %DialogueLabel

var is_typing := false
var is_skipping := false

const SILENT_CHARS = [".", ",", "!", "?", " ", "\n"]

const DIALOGUE_DELAYS = {
	"normal": 0.03,
	"comma": 0.15,
	"period": 0.3,
}


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
	dialogue_label.text = message
	dialogue_label.visible_characters = 0
	
	is_typing = true
	is_skipping = false

	while dialogue_label.visible_characters < dialogue_label.text.length():
		if is_skipping:
			break

		dialogue_label.visible_characters += 1
		
		var c := dialogue_label.text[dialogue_label.visible_characters - 1]
		if c not in SILENT_CHARS:
			AudioManager.play_sfx(AudioManager.SFX.TALK)

		var delay := DIALOGUE_DELAYS["normal"]
		match c:
			",":
				delay = DIALOGUE_DELAYS["comma"]
			".", "!", "?":
				delay = DIALOGUE_DELAYS["period"]

		await get_tree().create_timer(delay).timeout

	dialogue_label.visible_characters = dialogue_label.text.length()
	is_typing = false