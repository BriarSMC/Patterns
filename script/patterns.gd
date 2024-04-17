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
func arrange_pattern_boxes(picture: Sprite2D, patterns: Array[int]) -> void:
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
		printt("i", i, "pattern #", patterns[i], "pos", pattern_blocks[i].position)
	

# Private Methods


# Subclasses

