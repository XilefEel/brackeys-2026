class_name Game
extends Control

@export var levels: Array[LevelData] = []

@onready var dialogue_ui: DialogueUI = $DialogueUI
@onready var hud: HUD = $HUD

var current_level_index: int = 0
var spoken_guards: Array[int] = []

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

@onready var summary_labels: Array[Label] = [
	$RoomView/ToGuard1/SummaryLabel,
	$RoomView/ToGuard2/SummaryLabel,
	$RoomView/ToGuard3/SummaryLabel
]

var current_view: RoomViews = RoomViews.MAIN_ROOM

func _ready() -> void:
	switch_view(RoomViews.MAIN_ROOM, false)
	load_current_level()


func load_current_level() -> void:
	if levels.is_empty():
		push_error("No LevelData resources assigned")
		return

	spoken_guards.clear()
	hud.hide_tooltip()

	var current_level: LevelData = levels[current_level_index]
	hud.update_room_info(current_level.level_number)


func switch_view(target_view: RoomViews, play_sound: bool = true) -> void:
	if play_sound:
		AudioManager.play_sfx(AudioManager.SFX.CLICK)

	current_view = target_view
	for view_type in views.keys():
		views[view_type].visible = (view_type == target_view)


func _talk_guard(guard_index: int) -> void:
	var current_level := levels[current_level_index]
	
	if guard_index < 0 or guard_index >= current_level.guards.size():
		return

	if guard_index not in spoken_guards:
		spoken_guards.append(guard_index)

	var guard := current_level.guards[guard_index]
	dialogue_ui.play(guard.identifier, guard.statement)


func _choose_door(chosen_door: int) -> void:
	AudioManager.play_sfx(AudioManager.SFX.DOOR_OPEN)
	var current_level := levels[current_level_index]
	
	if chosen_door != current_level.safe_door_id:
		SceneTransition.change_scene("res://scenes/GameOver.tscn")
	else:
		current_level_index += 1

		await SceneTransition.fade_out()
		
		if current_level_index >= levels.size():
			dialogue_ui.play("VICTORY", "You escaped all rooms! You win!")
			current_level_index = 0
		else:
			dialogue_ui.play("SAFE", "Door %d was safe! Moving to next room..." % chosen_door)
			
		load_current_level()
		switch_view(RoomViews.MAIN_ROOM, false)
		await SceneTransition.fade_in()


func _on_to_door_1_pressed() -> void: switch_view(RoomViews.DOOR_1)
func _on_to_door_2_pressed() -> void: switch_view(RoomViews.DOOR_2)
func _on_to_door_3_pressed() -> void: switch_view(RoomViews.DOOR_3)

func _on_to_guard_1_pressed() -> void: switch_view(RoomViews.GUARD_1)
func _on_to_guard_2_pressed() -> void: switch_view(RoomViews.GUARD_2)
func _on_to_guard_3_pressed() -> void: switch_view(RoomViews.GUARD_3)

func _on_go_back_pressed() -> void: switch_view(RoomViews.MAIN_ROOM)

func _on_talk_guard_1_pressed() -> void: _talk_guard(0)
func _on_talk_guard_2_pressed() -> void: _talk_guard(1)
func _on_talk_guard_3_pressed() -> void: _talk_guard(2)

func _on_enter_door_1_pressed() -> void: _choose_door(1)
func _on_enter_door_2_pressed() -> void: _choose_door(2)
func _on_enter_door_3_pressed() -> void: _choose_door(3)


func _on_guard_hover_entered(guard_index: int) -> void:
	if current_view != RoomViews.MAIN_ROOM:
		return

	if guard_index in spoken_guards:
		var current_level := levels[current_level_index]
		if guard_index < current_level.guards.size():
			var guard := current_level.guards[guard_index]
			
			var label := summary_labels[guard_index]
			label.text = "%s\n\"%s\"" % [guard.identifier, guard.summary]
			label.show()


func _on_guard_hover_exited(guard_index: int) -> void:
	if guard_index < summary_labels.size():
		summary_labels[guard_index].hide()