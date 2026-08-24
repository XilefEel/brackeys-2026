extends Node

var audio_player: AudioStreamPlayer

@export var bgm_stream: AudioStream = preload("res://assets/bgm.mp3") 


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	audio_player = AudioStreamPlayer.new()
	
	if AudioServer.get_bus_index("BGM") != -1:
		audio_player.bus = &"BGM"
	else:
		audio_player.bus = &"Master"
		
	add_child(audio_player)
	
	if bgm_stream:
		audio_player.stream = bgm_stream
		audio_player.play()