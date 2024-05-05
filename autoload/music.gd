extends AudioStreamPlayer


const STREAM_LOOPS_2024_01_24_01_MONO_TRUNCATED = preload("res://audio/music/Stream Loops 2024-01-24_01-mono-truncated.mp3")
const STREAM_LOOPS_2024_03_20_02_MONO_MEDIUM_22050 = preload("res://audio/music/Stream Loops 2024-03-20_02-mono-medium-22050.mp3")


func game_start(sw: bool = true) -> void:
	if sw:
		stream = STREAM_LOOPS_2024_01_24_01_MONO_TRUNCATED
		volume_db = -10.0
		play()
	else:
		stop()

func game_play(sw: bool = true) -> void:
	if sw:
		stream = STREAM_LOOPS_2024_03_20_02_MONO_MEDIUM_22050
		volume_db = -12.0
		play()
	else:
		stop()
