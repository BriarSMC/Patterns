class_name Picture
extends Sprite2D


#region Description
# Refactor Picture-specific code from GamePlay into Picture
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

@export var pattern_node: Patterns
@export var overlay_node: Node2D

# public variables

# private variables

var game_play: Node2D

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
# Load the GamePlay (Parent node) pointer
func _ready() -> void:
	game_play = get_parent()


# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

# set_up_image(image)
# Start a new game round
#
# Parameters
#	config: Dictionary				Data for this image
#	image: String					The image path
#	patt: Array						Local array to hold the image's patterns
#	patt_available: Array			Array indicating what pattern have not been displayed yet
# Return
#	int								Number of patterns in this image
#==
# Step 1 - Reset GamePlay data and nodes for new picture
# Step 2 - Load the puzzle's image
# Step 3 - Make a copy of the patterns array, randomize it, and truncate it
# Step 4 - Set up the patterns available array as true
# Step 5 - Display the first N patterns in the pattern area
# Step 6 - Return the number of patterns
func set_up_image(config, image, patt: Array, patt_available: Array) -> int:
# Step 1
	game_play.emit_signal("reset_picture_requested")
# Step 2
	image.texture = load(config.image)
# Step 3
	patt.assign(config.pattern_list)
	patt.shuffle()		
	patt.resize(Constant.MAX_PATTERNS_TO_FIND)
# Step 4
	patt_available.resize(patt.size())
	patt_available.fill(true)	
# Step 5
	pattern_node.arrange_pattern_boxes(image, patt, patt_available)	
# Step 6
	return patt.size()


# Private Methods


# Subclasses


