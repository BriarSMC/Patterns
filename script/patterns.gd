class_name Patterns
extends Node2D


#region Description
# Display and manage the patterns the player needs to find
#
# The number of patterns to find displayed on the screen is governed by pattern_blocks
# which must be set in the editor inspector.
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

const BG_OFFSET = Vector2(0, 40 + 20)
const BG_SCALE = Vector2(0.8, 0.5)
const PATT_OFFSET = Vector2(0, 40 + 20)

# exports (The following properties must be set in the Inspector by the designer)

@export var pattern_blocks: Array[Sprite2D]

# public variables

# private variables
#
# box						The puzzle image's region_rect
# pattern_index				Array of the Patt* objects on the screen containing
#							the index of the pattern in GamePlay's patterns array
var box: Rect2
var pattern_index: Array

# onready variables

@onready var background = $Background


#endregion


# Virtual Godot methods


# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

# arrange_pattern_boxes(picture, patterns, available)
# Position pattern boxes on the screen
#
# Parameters
#	pictures: Sprite2D				Puzzle's picture
#	patterns: Array					Pattern frames to find
#	available: Array[bool]			Patterns still available to find
# Return
#	None
#==
# Step 1 - Calculate the positions for various images
# Step 2 - Position the background image
# Step 3 - Position the patterns and display then corresponding sub-image
func arrange_pattern_boxes(picture: Sprite2D, 
						   patterns: Array, 
						   available: Array[bool]) -> void:
# Step 1
	var x_center := get_viewport_rect().end.x / 2
	var y_pos := get_viewport_rect().end.y - 50 - Constant.PATTERN_SIZE
	var cur_x := x_center - ((pattern_blocks.size() / 2.0) * float(Constant.PATTERN_SIZE + 20)) 
# Step 2
	background.position = Vector2(x_center - 10 - Constant.PATTERN_SIZE / 2.0, y_pos) + BG_OFFSET
	background.scale = BG_SCALE
	background.visible = true
# Step 3
	pattern_index.clear()
	box = picture.region_rect
	
	for i in pattern_blocks.size():
		pattern_blocks[i].position.y = y_pos + PATT_OFFSET.y
		pattern_blocks[i].position.x = cur_x + PATT_OFFSET.x
		cur_x += Constant.PATTERN_SIZE + 20
		pattern_blocks[i].texture = picture.texture
		pattern_blocks[i].region_rect = patterns[i]
		pattern_index.append(i)
		pattern_blocks[i].visible = true
		available[i] = false
	
	

# is_a_current_pattern(index)
# Test if pattern referenced by index is in our pattern numbers array
#
# Parameters
#	index: int						Pattern number to look for
# Return
#	bool							true = Found, false = Not found
#==
# What the code is doing (steps)
func is_a_current_pattern(index: int) -> bool:
	if pattern_index.find(index) != -1:
		return true
	else:
		return false


# display_next_available_pattern(patt_index, patterns, avail)
# Replace the pattern referenced by patt_index with a new pattern
#
# Ok. So what we are doing here is add a new pattern to those displayed
# in Patterns. We keep an array (pattern_index) that has the index into patterns
# of the each pattern displayed in Patterns. We look into avail array to see if
# any patterns are left to display. If not, then just turn off the Patt* 
# corresponding to the index. Otherwise, set that pattern_index to the index
# passed in patt_index and change the region_rect to display the new image.
#
# Parameters
#	frame: int						Index of the pattern_block
#	patterns: Array[int]			List of pattern frames
#	avail: Array[bool]				List of available patterns
# Return
#	None
#==
# Find the next available pattern
# Get the index for the corresponding pattern index
# If frame isn't found, then just turn off that pattern box
# Otherwise, set the frame for that pattern box
func display_next_available_pattern(patt_index: int, patterns: Array, avail: Array[bool]) -> void:
	var p = avail.find(true)
	var i: int = pattern_index.find(patt_index)	
	
	if p < 0:
		pattern_blocks[i].visible = false
		pattern_index[i] = -1
	else:
		pattern_index[i] = p
		pattern_blocks[i].region_rect = patterns[p]
		avail[p] = false


# Private Methods


# Subclasses

