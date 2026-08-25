class_name GameOver
extends Control


func _on_main_menu_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	SceneTransition.change_scene("res://scenes/MainMenu.tscn")


func _on_restart_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	SceneTransition.change_scene("res://scenes/Game.tscn")

