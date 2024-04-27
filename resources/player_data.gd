class_name PlayerData extends Resource

#region Description
# last_player:
#	player name key
# players:
# 	player_data
#		"name_key"			String in uppercase
#		"name"				Name as entered
#		"current_picture"	Integer
#
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

const resource_file_name := "user://player_data.tres"

# exports (The following properties must be set in the Inspector by the designer)

@export var player_data := {}

# public variables

# private variables

# onready variables

#endregion


# Virtual Godot methods



# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

# save()
# Save resource to external file
#
# Parameters
#	None
# Return
#	None
#==
func save() -> void:
	ResourceSaver.save(self, resource_file_name)
	


# load_or_create()
# Load existing resource file or create a new one
#
# Parameters
#	None
# Return
#	None
#==
static func load_or_create() -> PlayerData:
	var res:  PlayerData = load(resource_file_name) as PlayerData
	if not res:
		res = PlayerData.new()
	return res
	

# Private Methods


# Subclasses
