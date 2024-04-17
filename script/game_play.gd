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

# exports (The following properties must be set in the Inspector by the designer)

@export var picture_area_vertical_offset := 60

# public variables

# private variables

var box: Rect2

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
func _ready() -> void:
	var vp = get_viewport_rect()
	picture.position.x = vp.end.x / 2 - Constant.PICTURE_WIDTH / 2
	picture.position.y = picture_area_vertical_offset
	box = Rect2(picture.position, 
			Vector2(Constant.PICTURE_WIDTH, Constant.PICTURE_HEIGHT))

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


# Subclasses

