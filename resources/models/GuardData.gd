class_name GuardData
extends Resource

enum Role {
    TRUTH_TELLER,
    LIAR,
    HALF_TRUTHER
}

enum Specialty {
    DOOR_SPEAKER,
    GUARD_SPEAKER
}

@export var identifier: String = "Shield Guard"
@export var role: Role = Role.TRUTH_TELLER
@export var specialty: Specialty = Specialty.DOOR_SPEAKER
@export var position: int = 0

@export var dialogue: Array[String] = []
@export var summary: String = ""