class_name Main
extends Control

@onready var dialogue_ui: DialogueUI = $DialogueUI

enum RoomViews {
	MAIN_ROOM,
	DOOR_1,
	DOOR_2,
	DOOR_3,
	GUARD_1,
	GUARD_2,
	GUARD_3,
}

@onready var views: Dictionary = {
	RoomViews.MAIN_ROOM: $RoomView,
	RoomViews.DOOR_1: $Door1View,
	RoomViews.DOOR_2: $Door2View,
	RoomViews.DOOR_3: $Door3View,
	RoomViews.GUARD_1: $Guard1View,
	RoomViews.GUARD_2: $Guard2View,
	RoomViews.GUARD_3: $Guard3View
}

var current_view: RoomViews = RoomViews.MAIN_ROOM

func _ready() -> void:
	switch_view(RoomViews.MAIN_ROOM)


func switch_view(target_view: RoomViews) -> void:
	current_view = target_view

	for view_type in views.keys():
		views[view_type].visible = (view_type == target_view)


func _on_to_door_1_pressed() -> void: switch_view(RoomViews.DOOR_1)
func _on_to_door_2_pressed() -> void: switch_view(RoomViews.DOOR_2)
func _on_to_door_3_pressed() -> void: switch_view(RoomViews.DOOR_3)

func _on_to_guard_1_pressed() -> void: switch_view(RoomViews.GUARD_1)
func _on_to_guard_2_pressed() -> void: switch_view(RoomViews.GUARD_2)
func _on_to_guard_3_pressed() -> void: switch_view(RoomViews.GUARD_3)

func _on_go_back_pressed() -> void: switch_view(RoomViews.MAIN_ROOM)

func _on_talk_guard_1_pressed() -> void:
	dialogue_ui.show_message("Guard 1", "Door 1 leads to death.")

func _on_talk_guard_2_pressed() -> void:
	dialogue_ui.show_message("Guard 2", "Guard 1 is telling the truth.")

func _on_talk_guard_3_pressed() -> void:
	dialogue_ui.show_message("Guard 3", "Door 2 is safe.")

func _on_enter_door_1_pressed() -> void: _choose_door(1)
func _on_enter_door_2_pressed() -> void: _choose_door(2)
func _on_enter_door_3_pressed() -> void: _choose_door(3)

func _choose_door(door_number: int) -> void:
	if door_number == 2:
		dialogue_ui.show_message("DEATH", "You opened Door 2 and fell into darkness!")
	else:
		dialogue_ui.show_message("SAFE", "You opened Door %d and escaped safely!" % door_number)
