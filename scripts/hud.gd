class_name HUD
extends CanvasLayer

@onready var room_label: Label = %RoomLabel
@onready var tooltip_panel: PanelContainer = %TooltipPanel
@onready var tooltip_label: Label = %TooltipLabel

func _ready() -> void:
	tooltip_panel.hide()


func _process(_delta: float) -> void:
	if tooltip_panel.visible:
		tooltip_panel.global_position = get_viewport().get_mouse_position() + Vector2(0, -32)


func update_room_info(level_number: int) -> void:
	room_label.text = "Room %d" % level_number


func show_tooltip(text: String) -> void:
	tooltip_label.text = text
	tooltip_panel.show()


func hide_tooltip() -> void:
	tooltip_panel.hide()
