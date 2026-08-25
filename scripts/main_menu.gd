class_name MainMenu
extends Control

@export_file("*.tscn") var game_scene: String = "res://scenes/Game.tscn"

@onready var play_button: Button = %Play
@onready var settings_button: Button = %Settings
@onready var quit_button: Button = %Quit


func _ready() -> void:
	if OS.get_name() == "Web":
		quit_button.hide()


func _on_play_pressed() -> void:
	if ResourceLoader.exists(game_scene):
		SceneTransition.change_scene(game_scene)
	else:
		push_error("Main game scene path is invalid: %s" % game_scene)


func _on_settings_pressed() -> void:
	SceneTransition.change_scene("res://scenes/SettingsMenu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
