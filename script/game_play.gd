class_name GamePlay
extends Node2D


#region Description
# Controls the game play
#
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

const patterns_to_find = [66, 77, 52, 75, 18, 69, 61, 41]

# exports (The following properties must be set in the Inspector by the designer)

@export var picture_area_vertical_offset := 60
@export var pattern_blocks: Array[Sprite2D]

# public variables

# private variables

var box: Rect2
var patterns: Array[int]

# onready variables

@onready var picture_area := $PictureArea
@onready var picture := $PictureArea/Picture

#endregion


# Virtual Godot methods

# _ready()
# Called when node is ready
#
# Parameters
#		None
# Return
#		None
#==
# Place the picture in the play area
# Create Rect2 of the picture
# Load the patterns to find and shuffle them
# Arrange the patterns to find boxes on screen
func _ready() -> void:
	var vp = get_viewport_rect()
	picture.position.x = vp.end.x / 2 - Constant.PICTURE_WIDTH / 2
	picture.position.y = picture_area_vertical_offset
	box = Rect2(picture.position, 
			Vector2(Constant.PICTURE_WIDTH, Constant.PICTURE_HEIGHT))

	patterns.assign(patterns_to_find)
	patterns.shuffle()
	printt(patterns_to_find, patterns)
		
	arrange_pattern_boxes()
	
	
		
# _input(event)
# Look for mouse clicks
#
# Parameters
#	event: InputEvent          	Seconds elapsed since last frame
# Return
#	None
#==

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.pressed): 
		var frame := get_frame_clicked(event.position)
		if frame >= 0:
			print("Frame: ", frame)

# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods


# Private Methods

# get_frame_clicked(pos)
# Check if mouse clicked in the picture.
# If so, then return what animation frame was clicked
#
# Parameters
#	pos: Vector2					Mouse position at time of click
# Return
#	int								Frame number corresponding to click position
#	-1								Click wasn't in the picture
#==
# Check if the position is in the box.
# If not, then return -1
# Calculate the frame number and return it
func get_frame_clicked(pos: Vector2) -> int:
	if not box.has_point(pos):
		return -1
		
	var frame_number: int 	
	var boxl = pos.x - box.position.x
	var boxh = pos.y - box.position.y
	var segx: int = boxl / Constant.PATTERN_SIZE
	var segy: int = boxh / Constant.PATTERN_SIZE
	frame_number = segx + (segy * 12)

	return frame_number


# arrange_pattern_boxes()
# Position pattern boxes on the screen
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func arrange_pattern_boxes() -> void:
	var x_center := get_viewport_rect().end.x / 2
	var y_pos := get_viewport_rect().end.y - 50 - Constant.PATTERN_SIZE
	var cur_x := x_center - (int(pattern_blocks.size() / 2) * (Constant.PATTERN_SIZE + 20)) 
	
	for i in pattern_blocks.size():
		pattern_blocks[i].position.y = y_pos
		pattern_blocks[i].position.x = cur_x
		cur_x += Constant.PATTERN_SIZE + 20
		pattern_blocks[i].texture = picture.texture
		pattern_blocks[i].hframes = Constant.HFRAME_COUNT
		pattern_blocks[i].vframes = Constant.VFRAME_COUNT
		pattern_blocks[i].frame = patterns[i]
		printt("i", i, "pattern #", patterns[i])
	

# Subclasses

