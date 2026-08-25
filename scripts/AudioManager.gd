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

var bgm_player: AudioStreamPlayer

var bgm_tracks: Dictionary = {}
var sfx_tracks: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = &"Music" if AudioServer.get_bus_index("Music") != -1 else &"Master"
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