class_name SettingsMenu
extends Control

@onready var master_slider: HSlider = %MasterVolumeSlider
@onready var sfx_slider: HSlider = %SFXVolumeSlider
@onready var bgm_slider: HSlider = %BGMVolumeSlider


func _on_back_button_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	SceneTransition.change_scene("res://scenes/MainMenu.tscn")