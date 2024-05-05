extends AudioStreamPlayer

const _351569__ETHRAIEL__BLIP = preload("res://audio/sfx/351569__ethraiel__blip.mp3")
const RETRO_EVENT_ACUTE_08 = preload("res://audio/sfx/Retro Event Acute 08.mp3")
const RETRO_SUCCESS_MELODY_04___ELECTRIC_PIANO_2 = preload("res://audio/sfx/Retro Success Melody 04 - electric piano 2.mp3")
const RETRO_BEEEP_20 = preload("res://audio/sfx/Retro Beeep 20.mp3")
const _455428__SERGEQUADRADO__NEXT_CHAPTER_PIANO_IDENT_MONO = preload("res://audio/sfx/455428__sergequadrado__next-chapter-piano-ident-mono.mp3")


func found_pattern() -> void:
	stream = _351569__ETHRAIEL__BLIP
	volume_db = -12.0
	play()
	
func found_all_patterns() -> void:
	stream = RETRO_EVENT_ACUTE_08
	volume_db = 0.0
	play()

func game_over() -> void:
	stream = RETRO_SUCCESS_MELODY_04___ELECTRIC_PIANO_2
	play()
	
func ui_button() -> void:
	stream = RETRO_BEEEP_20
	play()
	
func goto_game_play() -> void:
	stream = _455428__SERGEQUADRADO__NEXT_CHAPTER_PIANO_IDENT_MONO
	play()
