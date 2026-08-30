class_name ThreeDoorsView
extends Control

@onready var views: Dictionary = {
	Game.RoomViews.MAIN_ROOM: $RoomView,
	Game.RoomViews.DOOR_1: $Door1View,
	Game.RoomViews.DOOR_2: $Door2View,
	Game.RoomViews.DOOR_3: $Door3View,
	Game.RoomViews.GUARD_1: $Guard1View,
	Game.RoomViews.GUARD_2: $Guard2View,
	Game.RoomViews.GUARD_3: $Guard3View,
	Game.RoomViews.GUARD_4: $Guard4View,
	Game.RoomViews.GUARD_5: $Guard5View,
	Game.RoomViews.GUARD_6: $Guard6View,
}

@onready var summary_labels: Array[Label] = [
	$RoomView/ToGuard1/SummaryLabel,
	$RoomView/ToGuard2/SummaryLabel,
	$RoomView/ToGuard3/SummaryLabel,
	$RoomView/ToGuard4/SummaryLabel,
	$RoomView/ToGuard5/SummaryLabel,
	$RoomView/ToGuard6/SummaryLabel,
]

@onready var flower_overlays: Array[FlowerOverlay] = [
	$Guard1View/FlowerOverlay,
	$Guard2View/FlowerOverlay,
	$Guard3View/FlowerOverlay,
	$Guard4View/FlowerOverlay,
	$Guard5View/FlowerOverlay,
	$Guard6View/FlowerOverlay,
]

@onready var main_room_flower_overlays: Array[FlowerOverlay] = [
	$RoomView/ToGuard1/FlowerOverlay,
	$RoomView/ToGuard2/FlowerOverlay,
	$RoomView/ToGuard3/FlowerOverlay,
	$RoomView/ToGuard4/FlowerOverlay,
	$RoomView/ToGuard5/FlowerOverlay,
	$RoomView/ToGuard6/FlowerOverlay,
]

@onready var guard_buttons: Array[TextureButton] = [
	$RoomView/ToGuard1,
	$RoomView/ToGuard2,
	$RoomView/ToGuard3,
	$RoomView/ToGuard4,
	$RoomView/ToGuard5,
	$RoomView/ToGuard6,
]

@onready var guard_close_ups: Array[TextureButton] = [
	$Guard1View/Talk,
	$Guard2View/Talk,
	$Guard3View/Talk,
	$Guard4View/Talk,
	$Guard5View/Talk,
	$Guard6View/Talk,
]


func setup_guards(guards_by_position: Array[GuardData]) -> void:
	for i in range(guard_buttons.size()):
		var button_node := guard_buttons[i]
		var close_up_node := guard_close_ups[i]

		var guard: GuardData = guards_by_position[i] if i < guards_by_position.size() else null

		if guard != null:
			button_node.show()

			var dir := GuardData.Direction.CENTER
			if i in [0, 1]:
				dir = GuardData.Direction.RIGHT
			elif i in [2, 3]:
				dir = GuardData.Direction.CENTER
			elif i in [4, 5]:
				dir = GuardData.Direction.LEFT

			button_node.texture_normal = GuardData.get_texture(guard.specialty, dir)
			close_up_node.texture_normal = GuardData.get_texture(guard.specialty, GuardData.Direction.CENTER)
		else:
			button_node.hide()


func _on_to_door_1_pressed() -> void: get_parent().switch_view(Game.RoomViews.DOOR_1)
func _on_to_door_2_pressed() -> void: get_parent().switch_view(Game.RoomViews.DOOR_2)
func _on_to_door_3_pressed() -> void: get_parent().switch_view(Game.RoomViews.DOOR_3)

func _on_to_guard_1_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_1)
func _on_to_guard_2_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_2)
func _on_to_guard_3_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_3)
func _on_to_guard_4_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_4)
func _on_to_guard_5_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_5)
func _on_to_guard_6_pressed() -> void: get_parent().switch_view(Game.RoomViews.GUARD_6)

func _on_go_back_pressed() -> void: get_parent().switch_view(Game.RoomViews.MAIN_ROOM)

func _on_talk_guard_1_pressed() -> void: get_parent()._talk_guard(0)
func _on_talk_guard_2_pressed() -> void: get_parent()._talk_guard(1)
func _on_talk_guard_3_pressed() -> void: get_parent()._talk_guard(2)
func _on_talk_guard_4_pressed() -> void: get_parent()._talk_guard(3)
func _on_talk_guard_5_pressed() -> void: get_parent()._talk_guard(4)
func _on_talk_guard_6_pressed() -> void: get_parent()._talk_guard(5)

func _on_enter_door_1_pressed() -> void: get_parent()._choose_door(1)
func _on_enter_door_2_pressed() -> void: get_parent()._choose_door(2)
func _on_enter_door_3_pressed() -> void: get_parent()._choose_door(3)

func _on_to_guard_1_mouse_entered() -> void: get_parent()._on_guard_hover_entered(0)
func _on_to_guard_1_mouse_exited() -> void: get_parent()._on_guard_hover_exited(0)

func _on_to_guard_2_mouse_entered() -> void: get_parent()._on_guard_hover_entered(1)
func _on_to_guard_2_mouse_exited() -> void: get_parent()._on_guard_hover_exited(1)

func _on_to_guard_3_mouse_entered() -> void: get_parent()._on_guard_hover_entered(2)
func _on_to_guard_3_mouse_exited() -> void: get_parent()._on_guard_hover_exited(2)

func _on_to_guard_4_mouse_entered() -> void: get_parent()._on_guard_hover_entered(3)
func _on_to_guard_4_mouse_exited() -> void: get_parent()._on_guard_hover_exited(3)

func _on_to_guard_5_mouse_entered() -> void: get_parent()._on_guard_hover_entered(4)
func _on_to_guard_5_mouse_exited() -> void: get_parent()._on_guard_hover_exited(4)

func _on_to_guard_6_mouse_entered() -> void: get_parent()._on_guard_hover_entered(5)
func _on_to_guard_6_mouse_exited() -> void: get_parent()._on_guard_hover_exited(5)


func show_view(target_view: Game.RoomViews) -> void:
	for view_type in views:
		views[view_type].visible = (view_type == target_view)