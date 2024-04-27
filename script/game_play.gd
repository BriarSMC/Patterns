class_name GamePlay
extends Node2D


#region Description
# Controls the game play
#
#endregion


#region signals, enums, constants, variables, and such

# signals

signal found_count_zero_set
signal exit_game_requested

# enums

# constants

const found_frame = preload("res://scene/found_frame.tscn")

# exports (The following properties must be set in the Inspector by the designer)

@export var picture_area_vertical_offset := 43 + 50
@export var pattern_node: Patterns
@export var overlay_node: Node2D

# public variables

# private variables
#var patterns_to_find: Array
var picture_src: String
var box: Rect2
var patterns: Array[int]
var patterns_available: Array[bool]
var found_count: int
var time_elapsed: float
var game_running := false

# onready variables

@onready var picture_area := $PictureArea
@onready var picture := $PictureArea/Picture
@onready var frame_image := $PictureArea/Picture/FrameImage
@onready var background = $Background
@onready var picture_completed_dialog = $PictureCompletedDialog


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
# Step 5 - Position the frame around the puzzle image
# Step 6 - Add a QUIT button to the popup used when all patterns have been found
func _ready() -> void:
# Step 1
	exit_game_requested.connect(exit_game)	
	found_count_zero_set.connect(found_count_zero)
# Step 2
	var vp = get_viewport_rect()	
	var config = Config.get_picture(Config.current_picture)	
# Step 3
	found_count = set_up_image(config, picture, patterns, patterns_available)
	picture.region_rect = Rect2(0, 0, Constant.PICTURE_WIDTH, Constant.PICTURE_HEIGHT)
	picture.position.x = vp.end.x / 2.0 - (float(Constant.PICTURE_WIDTH) / 2.0)
	picture.position.y = picture_area_vertical_offset
# Step 4
	box = Rect2(picture.position, 
			Vector2(Constant.PICTURE_WIDTH, Constant.PICTURE_HEIGHT))
# Step 5
	var r: Rect2 = picture.get_rect()
	frame_image.position.x = r.position.x + (r.end.x/2)
	frame_image.position.y = r.position.y + (r.end.y/2)
	# Make sure the frame is behind the picture
	frame_image.z_index = -1
	
	picture_completed_dialog.add_cancel_button("Quit")	

# _process(delta)
# Called once per frame
#
# Parameters
#	delta: float            	Seconds elapsed since last frame
# Return
#	None
#==
# Increment timer if game is running
func _process(delta) -> void:
	if game_running:
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
# Step 3: If image was clicked
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
		var frame := get_frame_clicked(event.position)
# Step 3
		if frame >= 0 and patterns.find(frame) != -1:
			set_frame_found(frame)
			found_count -= 1
			if found_count == 0:
				found_count_zero_set.emit()
				

		
# Built-in Signal Callbacks

# Confirmation from PictureCompletedDialog
# Go to the next picture
func _on_picture_completed_dialog_confirmed():
	next_picture()
		

# Exit from PictureCompletedDialog
# Request game end
func _on_picture_completed_dialog_canceled():
	exit_game_requested.emit()


func _on_next_picture_pressed():
	next_picture()


# Quit button just exits the game
func _on_quit_pressed():
	exit_game()

# Custom Signal Callbacks

# found_count_zero()
# Signal handler for when they player has found all the patters.
#
# Parameters
#	None
# Return
#	None
#==
# Turn off the timers and any other _process statements
# Calculate how much time it took the player to find all the patterns
# Display the elapsed time in PictureCompletedDialog popup
func found_count_zero():
	game_running = false
	var hours = time_elapsed / 3600
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	picture_completed_dialog.dialog_text = "You found all patterns in %02d:%02d:%02d" % [hours, minutes, seconds]
	picture_completed_dialog.show()
	

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
	
# Public Methods


# Private Methods

# get_frame_clicked(pos)
# Check if mouse clicked in the picture.
# If so, then return what animation frame was clicked
#
# Parameters
#	pos: Vector2					Mouse position at time of click
# Return
#	int								Frame number corresponding to click position
#	-1								Click wasn't in the picture
#==
# Check if the position is in the box.
# If not, then return -1
# Calculate the frame number and return it
func get_frame_clicked(pos: Vector2) -> int:
	if not box.has_point(pos):
		return -1
		
	var frame_number: int 	
	var boxl = pos.x - box.position.x
	var boxh = pos.y - box.position.y
	var segx: int = boxl / Constant.PATTERN_SIZE
	var segy: int = boxh / Constant.PATTERN_SIZE
	frame_number = segx + (segy * 12)

	return frame_number


# set_frame_found(frame)
# Player cliced on one of our pattern frames
# Display an image over the frame so show the player found a pattern
#
# Parameters
#	frame: int						Frame number found
# Return
#	None
#==
# Calculate a position for the pattern-found-image
# Create a new instance of that image
# Set its position
# Add it to the Overlays node
# Set data indicating the player found the pattern
func set_frame_found(frame: int) -> void:
	var posx := frame % Constant.HFRAME_COUNT * float(Constant.PATTERN_SIZE) + float(Constant.PATTERN_SIZE) / 2.0
	var posy := float(frame / Constant.HFRAME_COUNT * Constant.PATTERN_SIZE + float(Constant.PATTERN_SIZE) / 2.0)
	var pos := Vector2(posx, posy)
	var overlay = found_frame.instantiate()
	overlay.position = pos
	overlay_node.add_child(overlay)

	pattern_node.set_new_pattern_frame(frame, patterns, patterns_available)
		
		
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
# What the code is doing (steps)
func set_up_image(config, image, patt: Array, patt_available: Array) -> int:
	time_elapsed = 0.0
	game_running = true
	image.texture = load(config.image)
	patt.assign(config.pattern_list)
	patt.shuffle()		
	patt_available.resize(patt.size())
	patt_available.fill(true)	

	pattern_node.arrange_pattern_boxes(image, patt, patt_available)	
	
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
	var config = Config.get_picture(Config.current_picture)	
	if config.is_empty():
		exit_game_requested.emit()
	found_count = set_up_image(config, picture, patterns, patterns_available)
	for obj: Node2D in overlay_node.get_children():
		obj.queue_free()
		
	
# Subclasses


