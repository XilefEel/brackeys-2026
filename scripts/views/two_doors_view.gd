class_name TwoDoorsView
extends Control

const ROOMS_IN_ORDER: Array[Game.RoomViews] = [
	Game.RoomViews.GUARD_1,
	Game.RoomViews.DOOR_1,
	Game.RoomViews.GUARD_2,
	Game.RoomViews.GUARD_3,
	Game.RoomViews.DOOR_2,
	Game.RoomViews.GUARD_4,
]

@onready var views: Dictionary = {
	Game.RoomViews.MAIN_ROOM: $RoomView,
	Game.RoomViews.DOOR_1: $Door1View,
	Game.RoomViews.DOOR_2: $Door2View,
	Game.RoomViews.GUARD_1: $Guard1View,
	Game.RoomViews.GUARD_2: $Guard2View,
	Game.RoomViews.GUARD_3: $Guard3View,
	Game.RoomViews.GUARD_4: $Guard4View,
}

@onready var summary_labels: Array[Label] = [
	$RoomView/ToGuard1/SummaryLabel,
	$RoomView/ToGuard2/SummaryLabel,
	$RoomView/ToGuard3/SummaryLabel,
	$RoomView/ToGuard4/SummaryLabel,
]

@onready var flower_overlays: Array[FlowerOverlay] = [
	$Guard1View/FlowerOverlay,
	$Guard2View/FlowerOverlay,
	$Guard3View/FlowerOverlay,
	$Guard4View/FlowerOverlay,
]

@onready var main_room_flower_overlays: Array[FlowerOverlay] = [
	$RoomView/ToGuard1/FlowerOverlay,
	$RoomView/ToGuard2/FlowerOverlay,
	$RoomView/ToGuard3/FlowerOverlay,
	$RoomView/ToGuard4/FlowerOverlay,
]

@onready var guard_buttons: Array[TextureButton] = [
	$RoomView/ToGuard1,
	$RoomView/ToGuard2,
	$RoomView/ToGuard3,
	$RoomView/ToGuard4,
]

@onready var guard_close_ups: Array[TextureButton] = [
	$Guard1View/Talk,
	$Guard2View/Talk,
	$Guard3View/Talk,
	$Guard4View/Talk,
]

var nav_sequence: Array[Game.RoomViews] = []

func setup_guards(guards_by_position: Array[GuardData]) -> void:
	nav_sequence.clear()

	for view_type in ROOMS_IN_ORDER:
		match view_type:
			Game.RoomViews.DOOR_1, Game.RoomViews.DOOR_2:
				nav_sequence.append(view_type)

			Game.RoomViews.GUARD_1:
				if _has_guard(0, guards_by_position): nav_sequence.append(view_type)
			Game.RoomViews.GUARD_2:
				if _has_guard(1, guards_by_position): nav_sequence.append(view_type)
			Game.RoomViews.GUARD_3:
				if _has_guard(2, guards_by_position): nav_sequence.append(view_type)
			Game.RoomViews.GUARD_4:
				if _has_guard(3, guards_by_position): nav_sequence.append(view_type)

	for i in range(guard_buttons.size()):
		var button_node := guard_buttons[i]
		var close_up_node := guard_close_ups[i]
		
		var guard := guards_by_position[i] if i < guards_by_position.size() else null

		if guard != null:
			button_node.show()
			button_node.texture_normal = GuardData.get_texture(guard.specialty, GuardData.Direction.CENTER)
			close_up_node.texture_normal = GuardData.get_texture(guard.specialty, GuardData.Direction.CENTER)
		else:
			button_node.hide()


func _has_guard(slot_idx: int, guards_by_position: Array[GuardData]) -> bool:
	return slot_idx < guards_by_position.size() and guards_by_position[slot_idx] != null


func navigate_right() -> void:
	_step_navigation(1)


func navigate_left() -> void:
	_step_navigation(-1)


func _step_navigation(step: int) -> void:
	if nav_sequence.is_empty():
		return

	var parent_game = get_parent()
	var current_view: Game.RoomViews = parent_game.current_view
	var current_idx := nav_sequence.find(current_view)

	if current_idx == -1:
		current_idx = 0 if step > 0 else nav_sequence.size() - 1
	else:
		current_idx = (current_idx + step + nav_sequence.size()) % nav_sequence.size()

	parent_game.switch_view(nav_sequence[current_idx])


func _on_to_door_1_pressed() -> void: get_parent().switch_view(Game.RoomViews.DOOR_1)
func _on_to_door_2_pressed() -> void: get_parent().switch_view(Game.RoomViews.DOOR_2)

func _on_to_guard_1_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_1)
func _on_to_guard_2_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_2)
func _on_to_guard_3_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_3)
func _on_to_guard_4_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_4)

func _on_go_back_pressed() -> void: get_parent().switch_view(Game.RoomViews.MAIN_ROOM)

func _on_talk_guard_1_pressed() -> void: get_parent()._talk_guard(0)
func _on_talk_guard_2_pressed() -> void: get_parent()._talk_guard(1)
func _on_talk_guard_3_pressed() -> void: get_parent()._talk_guard(2)
func _on_talk_guard_4_pressed() -> void: get_parent()._talk_guard(3)

func _on_enter_door_1_pressed() -> void: get_parent()._choose_door(1)
func _on_enter_door_2_pressed() -> void: get_parent()._choose_door(2)

func _on_to_guard_1_mouse_entered() -> void: get_parent()._on_guard_hover_entered(0)
func _on_to_guard_1_mouse_exited() -> void: get_parent()._on_guard_hover_exited(0)

func _on_to_guard_2_mouse_entered() -> void: get_parent()._on_guard_hover_entered(1)
func _on_to_guard_2_mouse_exited() -> void: get_parent()._on_guard_hover_exited(1)

func _on_to_guard_3_mouse_entered() -> void: get_parent()._on_guard_hover_entered(2)
func _on_to_guard_3_mouse_exited() -> void: get_parent()._on_guard_hover_exited(2)

func _on_to_guard_4_mouse_entered() -> void: get_parent()._on_guard_hover_entered(3)
func _on_to_guard_4_mouse_exited() -> void: get_parent()._on_guard_hover_exited(3)


func show_view(target_view: Game.RoomViews) -> void:
	for view_type in views:
		views[view_type].visible = (view_type == target_view)
