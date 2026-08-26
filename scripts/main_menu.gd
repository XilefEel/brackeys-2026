class_name MainMenu
extends Control

@onready var play_button: Button = %Play
@onready var settings_button: Button = %Settings
@onready var quit_button: Button = %Quit


func _ready() -> void:
	if OS.get_name() == "Web":
		quit_button.hide()


func _on_play_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	SceneTransition.change_scene("res://scenes/Game.tscn")


func _on_settings_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	SceneTransition.change_scene("res://scenes/SettingsMenu.tscn")


func _on_quit_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	get_tree().quit()
