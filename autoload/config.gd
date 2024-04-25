#class_name Config				# already defined by autoloader
extends Node

#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

var current_picture := 0
var image_data_res: ImageData 
var image_data := {}
var player_data_res: PlayerData
var player_data := {}

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
func _ready() -> void:
	image_data_res = ImageData.load_or_create()
	image_data = image_data_res.image_data
	player_data_res = PlayerData.load_or_create()
	player_data = player_data_res.player_data


# Built-in Signal Callbacks


# Custom Signal Callbacks

func get_picture(num: int) -> Dictionary:
	var key = ("%04d" % num)
	if Config.image_data.has(key):
		return {"image": Constant.PICTURE_DIR + Config.image_data[key].image, "pattern_list": Config.image_data[key].pattern_list}
	else:
		return {}

# Public Methods


# Private Methods


# Subclasses

