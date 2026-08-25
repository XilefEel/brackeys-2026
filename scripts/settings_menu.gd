class_name SettingsMenu
extends Control

@onready var master_slider: HSlider = %MasterVolumeSlider
@onready var sfx_slider: HSlider = %SFXVolumeSlider
@onready var bgm_slider: HSlider = %BGMVolumeSlider


func _on_back_button_pressed() -> void:
	SceneTransition.change_scene("res://scenes/MainMenu.tscn")