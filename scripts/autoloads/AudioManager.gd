extends Node

enum BGM {
	MAIN_MENU,
	GAME,
}

enum SFX {
	CLICK,
	DOOR_OPEN,
	TALK,
}

var main_menu_bgm: AudioStream = preload("res://assets/audio/bgm/main_menu_bgm.mp3")

var room_stems: Array[AudioStream] = [
	preload("res://assets/audio/bgm/room_1.ogg"),
	preload("res://assets/audio/bgm/room_2.ogg"),
	preload("res://assets/audio/bgm/room_3.ogg"),
	preload("res://assets/audio/bgm/room_4.ogg"),
	preload("res://assets/audio/bgm/room_5.ogg"),
	preload("res://assets/audio/bgm/room_6.ogg"),
]

var sfx_click: AudioStream = preload("res://assets/audio/sfx/click.mp3")
var sfx_door: AudioStream = preload("res://assets/audio/sfx/door.mp3")
var sfx_talk: AudioStream = preload("res://assets/audio/sfx/talk.mp3")

var sfx_tracks := {
	SFX.CLICK: sfx_click,
	SFX.DOOR_OPEN: sfx_door,
	SFX.TALK: sfx_talk,
}

var master_volume := 0.5
var bgm_volume := 0.5
var sfx_volume := 0.5

var bgm_player: AudioStreamPlayer
var room_layers: AudioStreamSynchronized


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	set_master_volume(master_volume)
	set_bgm_volume(bgm_volume)
	set_sfx_volume(sfx_volume)

	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = &"BGM" if AudioServer.get_bus_index("BGM") != -1 else &"Master"
	add_child(bgm_player)

	room_layers = AudioStreamSynchronized.new()
	room_layers.stream_count = room_stems.size()
	
	for i in range(room_stems.size()):
		room_layers.set_sync_stream(i, room_stems[i])


func play_bgm(track: BGM) -> void:
	match track:
		BGM.MAIN_MENU:
			stop_room_bgm()
			if bgm_player.stream == main_menu_bgm and bgm_player.playing:
				return

			bgm_player.stream = main_menu_bgm
			bgm_player.play()

		BGM.GAME:
			if bgm_player.playing:
				bgm_player.stop()

			start_room_bgm()


func start_room_bgm() -> void:
	if bgm_player.stream == room_layers and bgm_player.playing:
		return

	bgm_player.stream = room_layers
	bgm_player.play()

	for i in range(room_layers.stream_count):
		room_layers.set_sync_stream_volume(i, -80.0)

	set_room_layer(1)


func set_room_layer(room_number: int) -> void:
	var unlocked_layers: int = clampi(room_number, 1, room_layers.stream_count)

	for i in range(room_layers.stream_count):
		var target_db: float = 0.0 if i < unlocked_layers else -80.0
		room_layers.set_sync_stream_volume(i, target_db)


func stop_room_bgm() -> void:
	if bgm_player.stream == room_layers:
		bgm_player.stop()


func play_sfx(sound: SFX) -> void:
	var stream = sfx_tracks.get(sound)
	if not stream:
		return

	var sfx_player := AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.bus = &"SFX" if AudioServer.get_bus_index("SFX") != -1 else &"Master"
	add_child(sfx_player)

	sfx_player.play()
	sfx_player.finished.connect(sfx_player.queue_free)


func set_master_volume(value: float) -> void:
	master_volume = value
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	AudioServer.set_bus_mute(bus, value <= 0.001)


func set_bgm_volume(value: float) -> void:
	bgm_volume = value
	var bus := AudioServer.get_bus_index("BGM")
	if bus != -1:
		AudioServer.set_bus_volume_db(bus, linear_to_db(value))
		AudioServer.set_bus_mute(bus, value <= 0.001)


func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	var bus := AudioServer.get_bus_index("SFX")
	if bus != -1:
		AudioServer.set_bus_volume_db(bus, linear_to_db(value))
		AudioServer.set_bus_mute(bus, value <= 0.001)