class_name TwoDoorsView
extends Control

@onready var views: Dictionary = {
	Game.RoomViews.MAIN_ROOM: $RoomView,
	Game.RoomViews.DOOR_1: $Door1View,
	Game.RoomViews.DOOR_2: $Door2View,
	Game.RoomViews.GUARD_1: $Guard1View,
	Game.RoomViews.GUARD_2: $Guard2View
}

@onready var summary_labels: Array[Label] = [
	$RoomView/ToGuard1/SummaryLabel,
	$RoomView/ToGuard2/SummaryLabel
]

@onready var flower_overlays: Array[FlowerOverlay] = [
	$Guard1View/FlowerOverlay,
	$Guard2View/FlowerOverlay
]

@onready var main_room_flower_overlays: Array[FlowerOverlay] = [
	$RoomView/ToGuard1/FlowerOverlay,
	$RoomView/ToGuard2/FlowerOverlay
]

func _on_to_door_1_pressed() -> void: get_parent().switch_view(Game.RoomViews.DOOR_1)
func _on_to_door_2_pressed() -> void: get_parent().switch_view(Game.RoomViews.DOOR_2)

func _on_to_guard_1_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_1)
func _on_to_guard_2_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_2)

func _on_go_back_pressed() -> void: get_parent().switch_view(Game.RoomViews.MAIN_ROOM)

func _on_talk_guard_1_pressed() -> void: get_parent()._talk_guard(0)
func _on_talk_guard_2_pressed() -> void: get_parent()._talk_guard(1)

func _on_enter_door_1_pressed() -> void: get_parent()._choose_door(1)
func _on_enter_door_2_pressed() -> void: get_parent()._choose_door(2)

func _on_to_guard_1_mouse_entered() -> void: get_parent()._on_guard_hover_entered(0)
func _on_to_guard_1_mouse_exited() -> void: get_parent()._on_guard_hover_exited(0)

func _on_to_guard_2_mouse_entered() -> void: get_parent()._on_guard_hover_entered(1)
func _on_to_guard_2_mouse_exited() -> void: get_parent()._on_guard_hover_exited(1)


func show_view(target_view: Game.RoomViews) -> void:
	for view_type in views:
		views[view_type].visible = (view_type == target_view)
        