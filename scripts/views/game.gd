class_name Game
extends Control

@export var levels: Array[LevelData] = []

@onready var dialogue_ui: DialogueUI = $DialogueUI
@onready var hud: HUD = $HUD
@onready var room_title_card: RoomTitleCard = $RoomTitleCard

@onready var two_doors_view: TwoDoorsView = $TwoDoorsView
@onready var three_doors_view: ThreeDoorsView = $ThreeDoorsView

var active_layout: Control

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

@onready var amulet_overlay: PanelContainer = %AmuletOverlay

var guard_flower_states: Array[FlowerOverlay.FlowerState] = [
	FlowerOverlay.FlowerState.NONE,
	FlowerOverlay.FlowerState.NONE,
	FlowerOverlay.FlowerState.NONE
]

var current_view: RoomViews = RoomViews.MAIN_ROOM


func _ready() -> void:
	AudioManager.play_bgm(AudioManager.BGM.GAME)
	load_current_level()
	amulet_overlay.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("toggle_amulet"):
		if current_view == RoomViews.MAIN_ROOM and GlobalState.has_died_once:
			var current_level: LevelData = levels[current_level_index]
			
			if event.is_pressed():
				amulet_overlay.show_hint(current_level.amulet_hint)
				amulet_overlay.show()
			else:
				amulet_overlay.hide()
		return

	var guard_idx = -1

	match current_view:
		RoomViews.GUARD_1: guard_idx = 0
		RoomViews.GUARD_2: guard_idx = 1
		RoomViews.GUARD_3: guard_idx = 2

	if guard_idx == -1 or guard_idx >= active_layout.flower_overlays.size():
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
	active_layout.flower_overlays[guard_idx].update_display(flower_state)
	active_layout.main_room_flower_overlays[guard_idx].update_display(flower_state)

	AudioManager.play_sfx(AudioManager.SFX.CLICK)


func load_current_level() -> void:
	if levels.is_empty():
		push_error("No LevelData resources assigned")
		return

	spoken_guards.clear()

	var current_level: LevelData = levels[current_level_index]

	if current_level.door_count == 2:
		two_doors_view.show()
		three_doors_view.hide()
		active_layout = two_doors_view
	else:
		two_doors_view.hide()
		three_doors_view.show()
		active_layout = three_doors_view

	reset_flower_marks()
	switch_view(RoomViews.MAIN_ROOM, false)

	hud.update_room_info(current_level.level_number)
	room_title_card.show_title(current_level.level_number)


func switch_view(target_view: RoomViews, play_sound: bool = true) -> void:
	if play_sound:
		AudioManager.play_sfx(AudioManager.SFX.CLICK)

	current_view = target_view
	active_layout.show_view(target_view)


func _talk_guard(guard_index: int) -> void:
	var current_level := levels[current_level_index]
	
	if guard_index < 0 or guard_index >= current_level.guards.size():
		return

	if guard_index not in spoken_guards:
		spoken_guards.append(guard_index)

	var guard := current_level.guards[guard_index]
	dialogue_ui.play(guard.identifier, guard.dialogue, guard.specialty)


func _choose_door(chosen_door: int) -> void:
	AudioManager.play_sfx(AudioManager.SFX.DOOR_OPEN)
	var current_level := levels[current_level_index]
	
	if chosen_door != current_level.safe_door_id:
		SceneTransition.change_scene("res://scenes/views/GameOver.tscn")
	else:
		current_level_index += 1
		AudioManager.set_room_layer(current_level_index + 1)

		if current_level_index >= levels.size():
			SceneTransition.change_scene("res://scenes/views/WinScreen.tscn")
			return

		await SceneTransition.fade_out()
		
		switch_view(RoomViews.MAIN_ROOM, false)
		load_current_level()
		
		await SceneTransition.fade_in()


func reset_flower_marks() -> void:
	for i in range(guard_flower_states.size()):
		var none_state := FlowerOverlay.FlowerState.NONE

		guard_flower_states[i] = none_state

		if active_layout and i < active_layout.flower_overlays.size():
			active_layout.flower_overlays[i].update_display(none_state)
			active_layout.main_room_flower_overlays[i].update_display(none_state)


func _on_guard_hover_entered(guard_index: int) -> void:
	if current_view != RoomViews.MAIN_ROOM:
		return

	if guard_index in spoken_guards:
		var current_level := levels[current_level_index]

		if guard_index < current_level.guards.size():
			var guard := current_level.guards[guard_index]
			
			if guard_index < active_layout.summary_labels.size():
				var label: Label = active_layout.summary_labels[guard_index]
				label.text = "%s\n\"%s\"" % [guard.identifier, guard.summary]
				label.show()


func _on_guard_hover_exited(guard_index: int) -> void:
	if active_layout and guard_index < active_layout.summary_labels.size():
		active_layout.summary_labels[guard_index].hide()
