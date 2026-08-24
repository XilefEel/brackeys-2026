class_name Game
extends Control

@export var levels: Array[LevelData] = []

@onready var dialogue_ui: DialogueUI = $DialogueUI
@onready var hud: HUD = $HUD

var current_level_index: int = 0

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
	load_current_level()


func load_current_level() -> void:
	if levels.is_empty():
		push_error("No LevelData resources assigned in Inspector!")
		return
		
	hud.update_room_info(current_level_index + 1)


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

func _on_talk_guard_1_pressed() -> void: _talk_guard(1)
func _on_talk_guard_2_pressed() -> void: _talk_guard(2)
func _on_talk_guard_3_pressed() -> void: _talk_guard(3)

func _on_enter_door_1_pressed() -> void: _choose_door(1)
func _on_enter_door_2_pressed() -> void: _choose_door(2)
func _on_enter_door_3_pressed() -> void: _choose_door(3)


func _talk_guard(guard_number: int) -> void:
	var current_level = levels[current_level_index]
	var guard_text: String = ""

	match guard_number:
		1: guard_text = current_level.guard_1_text
		2: guard_text = current_level.guard_2_text
		3: guard_text = current_level.guard_3_text

	dialogue_ui.show_message("Guard %d" % guard_number, guard_text)


func _choose_door(chosen_door: int) -> void:
	var current_level = levels[current_level_index]
	
	if chosen_door == current_level.death_door:
		await SceneTransition.fade_out()
		current_level_index = 0
		load_current_level()
		dialogue_ui.show_message("DEATH", "Door %d was the death door! Resetting to Room 1..." % chosen_door)
		switch_view(RoomViews.MAIN_ROOM)
		await SceneTransition.fade_in()
		
	else:
		current_level_index += 1

		await SceneTransition.fade_out()
		
		if current_level_index >= levels.size():
			dialogue_ui.show_message("VICTORY", "You escaped all rooms! You win!")
			current_level_index = 0
		else:
			dialogue_ui.show_message("SAFE", "Door %d was safe! Moving to next room..." % chosen_door)
			
		load_current_level()
		switch_view(RoomViews.MAIN_ROOM)
		await SceneTransition.fade_in()