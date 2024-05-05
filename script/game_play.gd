class_name GamePlayNew
extends Node2D



#region Description
# Main game loop for the game
#
# Player finds a small square in the puzzle image matching a pattern image (small square
# in the puzzle image).
#
# The game displays a puzzle image to the player. Beneath this image is a list of pattern
# images in the Patterns area. The player needs to find these patterns in the puzzle image. 
# The user left clicks the # puzzle image where the player thinks the pattern image is located. 
# If player is correct, then the pattern image is replaced in the list of pattern images with 
# the next available pattern image. 
# 
# The puzzle's images are loaded from the image_data resource. This is a dictionary
# containing a dictionary of images. Each image has a puzzle number/key ("0000"-"9999").
# An image's dictionary entry has it's filename and an array of arrays with position data.
# Each subarray consists of two Rect2 elements. They are the local position and global
# position of each pattern in the puzzle image.
#
# When a new puzzle image is loaded we load the patterns array and patterns_available
# arrays. The patterns array is a copy of the Rect2 array in the resource file for the image.
# We then shuffle the patterns array for randomness in the game. The patterns_available
# array consist of a boolean for each entry in patterns. True means the corresponding patterns
# element is available to display in the Patterns area. 
#
# 
#endregion


#region signals, enums, constants, variables, and such

# signals

signal patterns_remaining_count_is_zero	# find_cound has reached zero
signal exit_game_requested				# we should exit the game
signal picture_complete_dialog_closed(sw: String)

# enums

# constants
#
# FOUND_FRAME	Used to draw a frame around a pattern location when player clicks (finds) it

const FOUND_FRAME = preload("res://scene/found_frame.tscn")
const PATTERN_OFFSET_VECTOR := Vector2(Constant.PATTERN_SIZE / 2, Constant.PATTERN_SIZE / 2)

# exports (The following properties must be set in the Inspector by the designer)
#
# picture_area_vertical_offset		Used to position the picture vertically on the screen
# pattern_node						Pointer to Patterns node
# overlay_node						Pointer for parent node for instantiated  FoundFrame nodes

@export var picture_area_vertical_offset := 43 + 50		# Kinda set visually in the 2D editor
@export var pattern_node: Patterns
@export var overlay_node: Node2D
@export var picture_completed_dialog: AcceptDialog
@export var no_more_pictures_dialog: AcceptDialog

# public variables

# private variables
#
# picture_rect						Rect2 of the puzzle's image
# patterns							Array of Rect2 defining each pattern to be found
# patterns_available				Corresponding patterns elements are available for Patterns area
# patterns_remaining_count			Number of patterns yet to be found
# time_elapsed						Amount of time player used solving the puzzle image
# add_delta_time					True = add the delta time the delta time to time_elapsed
#									The purpose of this switch is to determine when to add the
#									delta time in _process() to the time_elapsed variable. We set 
#									it to true when we display a new puzzle picture, and turn it
#									off when player has found all the patterns.
var picture_rect: Rect2
var patterns: Array	
var patterns_available: Array[bool]
var patterns_remaining_count: int
var time_elapsed: float
var add_delta_time := false
var picture_completed_quit_button: Button
var no_more_pictures := false

# onready variables

@onready var picture_area := $PictureArea
@onready var picture := $PictureArea/Picture
@onready var picture_border_image := $PictureArea/Picture/BorderImage
@onready var background = $Background

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
# Step 1 - Connect to our signals
# Step 2 - Place the picture in the play area
#	Get viewport dimensions
#	Get config image data for current picture
# Step 3 - Set up the image
#	Get the first puzzle image and set how many patterns it contains
#	Position the image on the screen
# Step 4 - Create Rect2 of the picture
# 	Used for detecting mouse button clicks on the picture
# Step 5 - Position the border around the puzzle image
func _ready() -> void:
# Step 1
	exit_game_requested.connect(exit_game)	
	patterns_remaining_count_is_zero.connect(find_count_zero)
	picture_complete_dialog_closed.connect(picture_completed)
# Step 2
	var vp = get_viewport_rect()	
	var config = Config.get_picture(Config.current_picture)	
# Step 3
	patterns_remaining_count = set_up_image(config, picture, patterns, patterns_available)
	picture.region_rect = Rect2(0, 0, Constant.PICTURE_WIDTH, Constant.PICTURE_HEIGHT)
	picture.position.x = vp.end.x / 2.0 - (float(Constant.PICTURE_WIDTH) / 2.0)
	picture.position.y = picture_area_vertical_offset
# Step 4
	picture_rect = Rect2(picture.position, 
			Vector2(Constant.PICTURE_WIDTH, Constant.PICTURE_HEIGHT))
# Step 5
	var r: Rect2 = picture.get_rect()
	picture_border_image.position.x = r.position.x + (r.end.x/2)
	picture_border_image.position.y = r.position.y + (r.end.y/2)
	# Make sure the frame is behind the picture
	picture_border_image.z_index = -1

# _process(delta)
# Called once per frame
#
# Parameters
#	delta: float            	Seconds elapsed since last frame
# Return
#	None
#==
# If the puzzle is active, then update the time elapsed
func _process(delta) -> void:
	if add_delta_time:
		time_elapsed += delta
	
# _input(event)
# Look for mouse clicks
#
# Parameters
#	event: InputEvent          	Seconds elapsed since last frame
# Return
#	None
#==
# We listen for two events:
#
# Step 1: Cancel - Just exit the game
# Step 2:  Left mouse button click
#	Find out if the player clicked on the image and, if so, which frame was clicked
# Step 3: If image was clicked and only if the pattern is in the list on the screen
#	Draw a box around the frame
#	Decrement the patterns found counter
#	If there are not more patterns to find, then emit the appropriate signal
func _input(event: InputEvent) -> void:
# Step 1
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
# Step 2		
	if (event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.pressed): 
		var patt_ndx := mouse_in_existing_pattern(event.position)
# Step 3
		if patt_ndx >= 0 and pattern_node.is_a_current_pattern(patt_ndx):
			set_pattern_found(patt_ndx)
			patterns_remaining_count -= 1
			if patterns_remaining_count == 0:
				patterns_remaining_count_is_zero.emit()
				


# Built-in Signal Callbacks


func _on_next_picture_pressed():
	next_picture()


func _on_quit_pressed():
	exit_game()

# Custom Signal Callbacks

# find_count_zero()
# Signal handler for when they player has found all the patterns.
#
# Parameters
#	None
# Return
#	None
#==
# Turn off the time_elapsed accumulator
# Calculate how much time components it took the player to find all the patterns
# Display the elapsed time in PictureCompletedDialog popup
func find_count_zero():
	add_delta_time = false
	picture_completed_dialog.next_picture(time_elapsed)
	

# exit_game()
# Signal handler for exiting the game
#
# Parameters
#	None
# Return
#	None
#==
# Just up and quit
func exit_game() -> void:
	get_tree().quit()


# picture_completed(sw)
# Confirmation from PictureCompletedDialog
#
# Parameters
#	sw: String						Which button was clicked
# Return
#	None
#==	
# If no more pics, then exit
# Otherwise check which button was clicked and act appropriately
func picture_completed(sw: String):
	match sw:
		"next":
			next_picture()
			if no_more_pictures:
				no_more_pictures_dialog.display_no_more_pictures()
				
		"quit":
			exit_game_requested.emit()


# Public Methods


# Private Methods

# set_pattern_found(index)
# Player cliced on one of our pattern frames
#
# Parameters
#	index: int					Index of the pattern found
# Return
#	None
#==
# Step 1 - Create a FoundFrame instance
# Step 2 - Place it on the screen
# Step 3 - Display a new pattern in the Patterns node
func set_pattern_found(index: int) -> void:
# Step 1
	var overlay = FOUND_FRAME.instantiate()
	overlay.pattern_index = index
# Step 2
	overlay_node.add_child(overlay)
	overlay.position = patterns[index].position + PATTERN_OFFSET_VECTOR
	overlay.region_rect = patterns[index]

# Step 3
	pattern_node.display_next_available_pattern(index, patterns, patterns_available)
	
# delete_found_frames()
# Remove all the FoundFrame objects from the puzzle image
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func delete_found_frames() -> void:
	for o in overlay_node.get_children():
		if o is FoundFrame:
			o.queue_free()


# get_frame_clicked(pos)
# Check if mouse clicked in one of the patterns displayed in Patterns
# If so, then return index of the pattern in patterns
#
# Parameters
#	pos: Vector2					Mouse position at time of click
# Return
#	int								Pattern index corresponding to click position
#	-1								Not one of the patterns
#==
# Step 1 - Return -1 if click outside of the puzzle image
# If not, then return -1
# Calculate the frame number and return it
func mouse_in_existing_pattern(pos: Vector2) -> int:
# Step 1
	if not picture_rect.has_point(pos):
		return -1
# Step 2
	var retval: int = -1
	for i in patterns.size():
		var rect2: Rect2 = patterns[i]
		rect2.position.x = rect2.position.x + picture_rect.position.x
		rect2.position.y = rect2.position.y + picture_rect.position.y
		if rect2.has_point(pos): 
			retval = i
	printt("Pattern clicked: ", retval)
	
	return retval


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
# Step 1 - Reset and turn on the timer
# Step 2 - Load the puzzle's image
# Step 3 - Make a copy of the patterns array, randomize it, and truncate it
# Step 4 - Set up the patterns available array as true
# Step 5 - Display the first N patterns in the pattern area
# Step 6 - Delete any FoundFrame objects from previous puzzle
# Step 7 - Return the number of patterns
func set_up_image(config, image, patt: Array, patt_available: Array) -> int:
# Step 1
	time_elapsed = 0.0
	add_delta_time = true
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
	delete_found_frames()
# Step 7
	return patt.size()


# next_picture()
# Go to the next picture
#
# Parameters
#	None
# Return
#	None
#==
# Point to the next puzzle image
# Get it's image data 
# If no more images exist, then exit the game
# Otherwise, load the image and set the pattern counter and delete any drawings
# from prevous play.
func next_picture() -> void:
	Config.current_picture += 1
	Config.current_player_data.current_picture = Config.current_picture
	Config.player_data.players[Config.current_player] = Config.current_player_data
	Config.player_data_res.save()

	var config = Config.get_picture(Config.current_picture)	
	if config.is_empty():
		no_more_pictures = true
		return
	patterns_remaining_count = set_up_image(config, picture, patterns, patterns_available)
	for obj: Node2D in overlay_node.get_children():
		obj.queue_free()


# Subclasses




