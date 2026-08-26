class_name Game
extends Control

@export var levels: Array[LevelData] = []

@onready var dialogue_ui: DialogueUI = $DialogueUI
@onready var hud: HUD = $HUD
@onready var room_title_card: RoomTitleCard = $RoomTitleCard

enum RoomViews {
	MAIN_ROOM,
	DOOR_1,
	DOOR_2,
	DOOR_3,
	GUARD_1,
	GUARD_2,
	GUARD_3,
}

var current_level_index: int = 0
var spoken_guards: Array[int] = []

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

@onready var flower_overlays: Array[FlowerOverlay] = [
	$Guard1View/FlowerOverlay,
	$Guard2View/FlowerOverlay,
	$Guard3View/FlowerOverlay
]

@onready var main_room_flower_overlays: Array[FlowerOverlay] = [
	$RoomView/ToGuard1/FlowerOverlay,
	$RoomView/ToGuard2/FlowerOverlay,
	$RoomView/ToGuard3/FlowerOverlay
]

var guard_flower_states: Array[FlowerOverlay.FlowerState] = [
	FlowerOverlay.FlowerState.NONE,
	FlowerOverlay.FlowerState.NONE,
	FlowerOverlay.FlowerState.NONE
]

var current_view: RoomViews = RoomViews.MAIN_ROOM


func _ready() -> void:
	AudioManager.play_bgm(AudioManager.BGM.GAME)
	switch_view(RoomViews.MAIN_ROOM, false)
	load_current_level()
	reset_flower_marks()


func _unhandled_input(event: InputEvent) -> void:
	var guard_idx = -1

	match current_view:
		RoomViews.GUARD_1: guard_idx = 0
		RoomViews.GUARD_2: guard_idx = 1
		RoomViews.GUARD_3: guard_idx = 2

	if guard_idx == -1:
		return

	var target_flower_state := FlowerOverlay.FlowerState.NONE

	if event.is_action_pressed("mark_truth"):
		target_flower_state = FlowerOverlay.FlowerState.TRUTH
	elif event.is_action_pressed("mark_lie"):
		target_flower_state = FlowerOverlay.FlowerState.LIAR
	elif event.is_action_pressed("mark_half"):
		target_flower_state = FlowerOverlay.FlowerState.HALF_TRUTH
	else:
		return

	if guard_flower_states[guard_idx] == target_flower_state:
		guard_flower_states[guard_idx] = FlowerOverlay.FlowerState.NONE
	else:
		guard_flower_states[guard_idx] = target_flower_state

	var flower_state := guard_flower_states[guard_idx]
	flower_overlays[guard_idx].update_display(flower_state)
	main_room_flower_overlays[guard_idx].update_display(flower_state)

	AudioManager.play_sfx(AudioManager.SFX.CLICK)


func load_current_level() -> void:
	if levels.is_empty():
		push_error("No LevelData resources assigned")
		return

	spoken_guards.clear()
	reset_flower_marks()

	var current_level: LevelData = levels[current_level_index]
	hud.update_room_info(current_level.level_number)
	room_title_card.show_title(current_level.level_number)


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

		switch_view(RoomViews.MAIN_ROOM, false)
		load_current_level()
		await SceneTransition.fade_in()


func reset_flower_marks() -> void:
	for i in range(guard_flower_states.size()):
		var none_state := FlowerOverlay.FlowerState.NONE

		guard_flower_states[i] = none_state
		flower_overlays[i].update_display(none_state)
		main_room_flower_overlays[i].update_display(none_state)


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
