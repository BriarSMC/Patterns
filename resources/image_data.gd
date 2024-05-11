class_name ImageData extends Resource

#region Description
# Image Data Resource
#
# Used to load/save image data
# 
# NOTE: save() is not used by this game. It is meant only for the PatternsTool
# used to build the image data structure.
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

const resource_file_name := "image_data.tres"

# exports (The following properties must be set in the Inspector by the designer)

@export var image_data := {}

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
#func save() -> void:
	#ResourceSaver.save(self, resource_file_name)
	


# load_or_create(ndx)
# Load specified resource file 
# Error if doesn't exist
# Parameters
#	ndx: int					Index of the image config to load
# Return
#	None
#==
static func load_or_create(dir: String) -> ImageData:
	var res:  ImageData = load(dir + resource_file_name) as ImageData
	if not res:
		push_error("ImageData.load_or_create invalid parameter ndx: ", dir)
		assert(false, "ImageData.load_or_create invalid parameter ndx: " + dir)
		return null
	return res
	

# Private Methods


# Subclasses
