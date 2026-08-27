class_name AmuletOverlay
extends PanelContainer

@onready var amulet_hint_label: Label = %AmuletHint


func show_hint(hint_text: String) -> void:
	amulet_hint_label.text = hint_text
	show()