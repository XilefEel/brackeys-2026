class_name FlowerOverlay
extends Control

enum FlowerState {
	NONE,
	TRUTH,
	LIAR,
	HALF_TRUTH
}

@onready var truth_flower: TextureRect = $TruthFlower
@onready var liar_flower: TextureRect = $LiarFlower
@onready var half_truth_flower: TextureRect = $HalfTruthFlower


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	for child in get_children():
		if child is Control:
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
	update_display(FlowerState.NONE)


func update_display(state: FlowerState) -> void:
	truth_flower.visible = (state == FlowerState.TRUTH)
	liar_flower.visible = (state == FlowerState.LIAR)
	half_truth_flower.visible = (state == FlowerState.HALF_TRUTH)
