#class_name Config				# already defined by autoloader
extends Node

#region Description
# This is the configuration "file" for the game.
#
# It does the following:
#
#	o Keeps track of the current picture key
#	o Loads the image data from the resource file
#	o Keeps a global for this data
#	o Loads the player data from the resource file
#	o Keeps a global for this data
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

var current_picture := 0				# Current picture to solve
var current_player_data := {}			# Current player data
var current_player: String
var image_data_res: ImageData 			# Pointer to the image data resource node
var image_data := {}					# Pointer to the image data 
var player_data_res: PlayerData			# Pointer to the player data resource node
var player_data := {}					# Pointer to the player data 

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
# Get the image data from the resource file
# Get the player data from the resource file
func _ready() -> void:
	image_data_res = ImageData.load_or_create()
	image_data = image_data_res.image_data
	player_data_res = PlayerData.load_or_create()
	player_data = player_data_res.player_data


# Built-in Signal Callbacks

# Custom Signal Callbacks


# Public Methods

# get_picture(num)
# Return the image data corresponding to the value in num
#
# Parameters
#	num: int						Key into the image data
# Return
#	Dictionary						A dictionary with the image's data
#==
# Convert the value in num to "0000" format
# See if the key exists in the image dictionary
# If so, then return a dictionary containing the image's data
# Otherwise, return an empty dictionary
func get_picture(num: int) -> Dictionary:
	var key = ("%04d" % num)
	if Config.image_data.has(key):
		return {"image": Constant.PICTURE_DIR + Config.image_data[key].image, "pattern_list": Config.image_data[key].pattern_list}
	else:
		return {}
		

# Private Methods


# Subclasses

