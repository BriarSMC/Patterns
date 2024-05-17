class_name Content
extends Node2D


#region Description
# This node is repsonsible to controlling access to the game's puzzle 
# content (directories, images and ImageData resources).
#
# The content for this game is stored in multiple directories. Each
# directory is a set of puzzle images plus a configuration file 
# for the images in that directory.
#
# These directories are numbered 000-999 (as 3-character strings). 000
# is delivered as part the game's executable image and is in the res://
# tree. The others are in the user:// tree.
# 
# The player_data resource always keeps which directory the player is using
# and what image is next for them. When the player exhausts the images in
# the directory, the game will do the following:
#
# 	1) See if the next directory in the sequence exists.
#	2) If so, then point to the next directory and the first picture in it.
#	3) If not, then see if we have a http connection to our remote
#	   repository.
#	4) If not, then exit the game.
#	5) Otherwise, ask the player if we should download the next available
#	   image set.
#	6) If not, then exit the game.
#	7) If so, then download the next image set and store it in user://.
#	8) Set current directory and picture.
#
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

var content_dirs: PackedStringArray = [] # List of directories in the content directory
var image_data_res: ImageData 			# Pointer to the image data resource node
var image_data := {}					# Pointer to the image data 

# onready variables

#endregion


# Virtual Godot methods


# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

# load_content_dirs()
# Build array of Content Directories
#
#
# Parameters
#	None
# Return
#	None
#==
# Step 1: Make distribution directory first in list
# Step 2: Loop through all the downloaded directories and append to list
func load_content_dirs() -> void:
# Step 1
	content_dirs.append(Constant.DIST_CONTENT_DIR + "000/")
# Step 2
	var dir = DirAccess.open(Constant.CONTENT_DIR)
	if dir:
		dir.list_dir_begin()
		var dir_name = dir.get_next()
		while not dir_name.is_empty():
			content_dirs.append(Constant.CONTENT_DIR + dir_name + "/")
			dir_name = dir.get_next()
	print("Content dirs: ", content_dirs)
	

# load_image_config(index)
# Load image configuration for the specified directory
#
# Parameters
#	index: int						Index into the content_dirs array
# Return
#	true							Image resource file found and loaded
# 	false							No image resource file found
#==
# Load the resource file
# If failed, then return a fail
# Otherwise, load the data from the image resource file
func load_image_config(index: int) -> bool:
	image_data_res = ImageData.load_or_create(content_dirs[index])
	if not image_data_res:
		return false
	else:
		image_data = image_data_res.image_data
		return true
	
# get_picture(dir_ndx, image_ndx)
# Return the image data corresponding to the value in num
#
# Parameters
#	dir_ndx: int					Index in current_dirs for this image
#	image_ndx: int					Key into the image data
# Return
#	Dictionary						A dictionary with the image's data
#==
# Convert the value in num to "0000" format
# See if the key exists in the image dictionary
# If so, then return a dictionary containing the image's data
# Otherwise, return an empty dictionary
func get_picture(dir_ndx: int, image_ndx: int) -> Dictionary:
	var key: String = ("%04d" % image_ndx)
	if image_data.has(key):
		return {"image": content_dirs[dir_ndx] + image_data[key].image, "pattern_list": image_data[key].pattern_list}
	else:
		return {}
		
# get_next_content_dir()
# Get the next content directory
#
# Parameters
#	None
# Return
#	int								Index into content_dirs of the next directory
#	-1								No more directories
#==
# See if any more directories exist.
# If so, return the index
# Otherwise return a -1
func get_next_content_dir() -> int:
	Config.current_dir += 1
	return content_dirs.find("%03d" % (Config.current_dir))
	
	
# Private Methods
			
# Subclasses

