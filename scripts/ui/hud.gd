class_name HUD
extends CanvasLayer

@onready var room_label: Label = %RoomLabel

func _ready() -> void:
	pass


func update_room_info(level_number: int) -> void:
	room_label.text = "Room %d" % level_number
