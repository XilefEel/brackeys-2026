extends Node

enum BGM {
	GAME,
}

enum SFX {
	CLICK,
	DOOR_OPEN,
}

@export var bgm: AudioStream = preload("res://assets/bgm.mp3")
@export var sfx_click: AudioStream = preload("res://assets/click.mp3")
@export var sfx_door: AudioStream = preload("res://assets/door.mp3")

var master_volume: float = 0.5
var bgm_volume: float = 0.5
var sfx_volume: float = 0.5

var bgm_player: AudioStreamPlayer

var bgm_tracks: Dictionary = {}
var sfx_tracks: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	set_master_volume(master_volume)
	set_bgm_volume(bgm_volume)
	set_sfx_volume(sfx_volume)
	
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = &"BGM" if AudioServer.get_bus_index("BGM") != -1 else &"Master"
	add_child(bgm_player)
	
	bgm_tracks = {
		BGM.GAME: bgm
	}
	
	sfx_tracks = {
		SFX.CLICK: sfx_click,
		SFX.DOOR_OPEN: sfx_door,
	}
	
	play_bgm(BGM.GAME)


func play_bgm(track: BGM) -> void:
	var stream = bgm_tracks.get(track)
	if not stream:
		return
		
	if bgm_player.stream == stream and bgm_player.playing:
		return
		
	bgm_player.stream = stream
	bgm_player.play()


func play_sfx(sound: SFX) -> void:
	var stream = sfx_tracks.get(sound)
	if not stream:
		return
		
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.bus = &"SFX" if AudioServer.get_bus_index("SFX") != -1 else &"Master"
	add_child(sfx_player)
	
	sfx_player.play()
	sfx_player.finished.connect(sfx_player.queue_free)


func set_master_volume(value: float) -> void:
	master_volume = value
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	AudioServer.set_bus_mute(bus, value <= 0.001)


func set_bgm_volume(value: float) -> void:
	bgm_volume = value
	var bus = AudioServer.get_bus_index("BGM")
	if bus != -1:
		AudioServer.set_bus_volume_db(bus, linear_to_db(value))
		AudioServer.set_bus_mute(bus, value <= 0.001)


func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	var bus = AudioServer.get_bus_index("SFX")
	if bus != -1:
		AudioServer.set_bus_volume_db(bus, linear_to_db(value))
		AudioServer.set_bus_mute(bus, value <= 0.001)