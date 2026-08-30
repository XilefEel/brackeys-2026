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

enum Direction {
    LEFT,
    CENTER,
    RIGHT
}

@export var identifier: String = "Shield Guard"
@export var role: Role = Role.TRUTH_TELLER
@export var specialty: Specialty = Specialty.DOOR_SPEAKER
@export var position: int = 0

@export var dialogue: Array[String] = []
@export var summary: String = ""

static func get_texture(guard_specialty: Specialty, guard_direction: Direction = Direction.CENTER) -> Texture2D:
    var texture_path: String = "res://assets/ui/guards/"

    var specialty_str: String = ""
    match guard_specialty:
        Specialty.DOOR_SPEAKER:
            specialty_str = "door_speaker"
        Specialty.GUARD_SPEAKER:
            specialty_str = "guard_speaker"
    
    var direction_str: String = ""
    match guard_direction:
        Direction.LEFT:
            direction_str = "_left"
        Direction.CENTER:
            direction_str = ""
        Direction.RIGHT:
            direction_str = "_right"
    
    return load("%s%s%s.png" % [texture_path, specialty_str, direction_str])