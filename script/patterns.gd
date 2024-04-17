class_name Patterns
extends Node2D


#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

@export var pattern_blocks: Array[Sprite2D]

# public variables

# private variables

var pattern_numbers: Array[int]

# onready variables

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
# What the code is doing (steps)
func _ready() -> void:
	pass



# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

# arrange_pattern_boxes(picture, patterns)
# Position pattern boxes on the screen
#
# Parameters
#	pictures: Sprite2D				Puzzle's picture
#	patterns: Array[int]			Pattern frames to find
# Return
#	None
#==
# What the code is doing (steps)
func arrange_pattern_boxes(picture: Sprite2D, 
						   patterns: Array[int], 
						   available: Array[bool]) -> void:
	var x_center := get_viewport_rect().end.x / 2
	var y_pos := get_viewport_rect().end.y - 50 - Constant.PATTERN_SIZE
	var cur_x := x_center - ((pattern_blocks.size() / 2.0) * float(Constant.PATTERN_SIZE + 20)) 
	
	for i in pattern_blocks.size():
		pattern_blocks[i].position.y = y_pos
		pattern_blocks[i].position.x = cur_x
		cur_x += Constant.PATTERN_SIZE + 20
		pattern_blocks[i].texture = picture.texture
		pattern_blocks[i].hframes = Constant.HFRAME_COUNT
		pattern_blocks[i].vframes = Constant.VFRAME_COUNT
		pattern_blocks[i].frame = patterns[i]
		printt("i", i, "pattern #", patterns[i], "pos", pattern_blocks[i].position)
		pattern_numbers.append(patterns[i])
		available[i] = false
	

# set_pattern_frame(ndx, patterns, avail)
# Set the frame number for a pattern node
#
# Parameters
#	frame: int						Index of the pattern_block
#	patterns: Array[int]			List of pattern frames
#	avail: Array[bool]				List of available patterns
# Return
#	None
#==
# What the code is doing (steps)
func set_new_pattern_frame(frame: int, patterns: Array[int], avail: Array[bool]) -> void:
	var p = avail.find(true)
	var i: int = pattern_numbers.find(frame)	
	
	if p < 0:
		pattern_blocks[i].visible = false
		pattern_numbers[i] = -1
	else:
		pattern_numbers[i] = patterns[p]
		pattern_blocks[i].frame = patterns[p]
		avail[p] = false


# Private Methods


# Subclasses

