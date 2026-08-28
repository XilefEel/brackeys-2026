extends Control

@onready var parent := get_parent() 

func _on_to_door_1_pressed() -> void: parent.switch_view(parent.RoomViews.DOOR_1)
func _on_to_door_2_pressed() -> void: parent.switch_view(parent.RoomViews.DOOR_2)

func _on_to_guard_1_pressed() -> void: parent.switch_view(parent.RoomViews.GUARD_1)
func _on_to_guard_2_pressed() -> void: parent.switch_view(parent.RoomViews.GUARD_2)

func _on_go_back_pressed() -> void: parent.switch_view(parent.RoomViews.MAIN_ROOM)

func _on_talk_guard_1_pressed() -> void: parent._talk_guard(0)
func _on_talk_guard_2_pressed() -> void: parent._talk_guard(1)

func _on_enter_door_1_pressed() -> void: parent._choose_door(1)
func _on_enter_door_2_pressed() -> void: parent._choose_door(2)