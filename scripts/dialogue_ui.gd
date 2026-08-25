class_name DialogueUI
extends CanvasLayer

@onready var character_label: Label = %CharacterLabel
@onready var message_label: Label = %MessageLabel
@onready var continue_button: Button = %ContinueButton

func _ready() -> void:
	hide()
	continue_button.pressed.connect(func():
		AudioManager.play_sfx(AudioManager.SFX.CLICK)
		hide()
	)

func show_message(character_name: String, text: String) -> void:
	character_label.text = character_name
	message_label.text = text
	show()
