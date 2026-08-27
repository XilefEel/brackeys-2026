class_name RoomTitleCard
extends CanvasLayer

@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var container: Control = %TitleContainer


func _ready() -> void:
	self.show()
	container.modulate.a = 0.0


func show_title(room_number: int, subtitle: String = "Find the Safe Door") -> void:
	container.visible = true
	title_label.text = "ROOM %d" % room_number
	subtitle_label.text = subtitle

	var tween := create_tween()

	tween.tween_property(container, "modulate:a", 1.0, 0.4)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_interval(1.25)

	tween.tween_property(container, "modulate:a", 0.0, 0.4)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)

	tween.finished.connect(func():
		container.visible = false	
	)
