class_name GameOver
extends Control


func _on_main_menu_pressed() -> void:
	SceneTransition.change_scene("res://scenes/MainMenu.tscn")


func _on_restart_pressed() -> void:
	SceneTransition.change_scene("res://scenes/Game.tscn")

