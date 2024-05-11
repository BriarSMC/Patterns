#class_name Config				# already defined by autoloader
extends Node

#region Description
# This is the configuration "file" for the game.
#
# It does the following:
#
#	o Keeps track of the current picture key
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

var current_player: String
var player_data_res: PlayerData			# Pointer to the player data resource node
var player_data := {}					# Pointer to the player data 
var current_picture := 0				# Current picture to solve
var current_dir := 0					# Current content directory
var current_player_data := {}			# Current player data

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
	player_data_res = PlayerData.load_or_create()
	player_data = player_data_res.player_data


# Built-in Signal Callbacks

# Custom Signal Callbacks


# Public Methods

# Private Methods

# Subclasses

