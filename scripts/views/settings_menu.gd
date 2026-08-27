class_name SettingsMenu
extends Control

@onready var master_slider: HSlider = %MasterVolumeSlider
@onready var sfx_slider: HSlider = %SFXVolumeSlider
@onready var bgm_slider: HSlider = %BGMVolumeSlider

func _ready() -> void:
	master_slider.value = AudioManager.master_volume
	bgm_slider.value = AudioManager.bgm_volume
	sfx_slider.value = AudioManager.sfx_volume


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioManager.set_master_volume(value)


func _on_bgm_volume_slider_value_changed(value: float) -> void:
	AudioManager.set_bgm_volume(value)


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)


func _on_back_button_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SFX.CLICK)
	SceneTransition.change_scene("res://scenes/views/MainMenu.tscn")
