class_name Typewriter

const SILENT_CHARS = [".", ",", "!", "?", " ", "\n"]

const DIALOGUE_DELAYS = {
	"normal": 0.03,
	"comma": 0.15,
	"period": 0.3,
}


static func run(
	label: Label,
	message: String,
	tree: SceneTree,
	skip_flag: Callable,
	speaker: AudioManager.SFX = AudioManager.SFX.TYPE
) -> void:
	label.text = message
	label.visible_characters = 0

	while label.visible_characters < label.text.length():
		if skip_flag.call():
			break

		label.visible_characters += 1

		var c := label.text[label.visible_characters - 1]
		if c not in SILENT_CHARS:
			AudioManager.play_sfx(speaker)

		var delay: float = DIALOGUE_DELAYS["normal"]
		match c:
			",":
				delay = DIALOGUE_DELAYS["comma"]
			".", "!", "?":
				delay = DIALOGUE_DELAYS["period"]

		await tree.create_timer(delay).timeout

	label.visible_characters = label.text.length()
