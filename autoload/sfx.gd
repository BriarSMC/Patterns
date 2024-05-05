extends AudioStreamPlayer

const _351569__ETHRAIEL__BLIP = preload("res://audio/sfx/351569__ethraiel__blip.mp3")
const RETRO_EVENT_ACUTE_08 = preload("res://audio/sfx/Retro Event Acute 08.mp3")
const RETRO_SUCCESS_MELODY_04___ELECTRIC_PIANO_2 = preload("res://audio/sfx/Retro Success Melody 04 - electric piano 2.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
