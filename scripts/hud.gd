class_name HUD
extends CanvasLayer

@onready var room_label: Label = %RoomLabel


func update_room_info(room_number: int = 1) -> void:
	room_label.text = "Room %d" % room_number


func _on_settings_button_pressed() -> void:
	print("Settings pressed!")