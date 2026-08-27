class_name LevelData
extends Resource

@export_category("Level Config")
@export var level_number: int = 1
@export var door_count: int = 3
@export var safe_door_id: int = 1
@export_multiline var amulet_hint: String = ""

@export_category("Guard Configurations")
@export var guards: Array[GuardData] = []