class_name NoMorePicturesDialog
extends AcceptDialog

#region Description
# This dialog popup is used both when the player has found all the patterns in the 
# picture and when no pictures are left to solve.
#
# The default settings are for picture complete. When the pictures are exhausted, then
# the AcceptDialog must be modified to reflect this.
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

const DOWNLOAD_TEXT := "You have solved the last picture. More pictures are available " + \
			"for you to download. Do you want to download additional puzzles?"
			
# exports (The following properties must be set in the Inspector by the designer)

@export var content: Content

# public variables

# private variables

var content_config: Dictionary = {}
var more_content_available: bool
var cancel_button: Button

# onready variables

@onready var http = $HTTPManager

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
# Center the text in the panel
# Remove any cancel button we may have added
# Don't display as default
func _ready() -> void:
	# https://forum.godotengine.org/t/how-to-center-dialog-text-of-a-acceptdialog/16235/5
	get_child(1, true).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if cancel_button:
		remove_button(cancel_button)
	visible = false

	
# Built-in Signal Callbacks

func _on_confirmed():
	if not more_content_available:
		get_parent().emit_signal("exit_game_requested")
	else:
		get_parent().emit_signal("download_content_requested")
		

func _on_canceled():
	visible = false
	
	
# Custom Signal Callbacks

# _on_config_completed()
# Called when the http request to download the config is completed
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func _on_config_completed(_result, response_code, _headers, body) -> void:
	if response_code == 200:
		var json := JSON.new()
		json.parse(body.get_string_from_utf8())
		content_config = json.get_data()

# Public Methods

# Setters/Getters

func set_content_pointer(ptr: Content) -> void:
	content = ptr
	
	
# display_no_more_pictures()
# Display the NoMorePicturesDialog
#
# Parameters
#	None
# Return
#	None
#==
# Step 1 - Let the player see us
# Step 2 - Just return and wait for the OK if network not available
# Step 3 - If additional remote content is available, then ask if
#		   player wants to download it.
#		   The signal handlers for the buttons will act accordingly
func display_no_more_pictures() -> void:
	visible = true
	
	more_content_available = false
	if not await http.we_have_http():
		return
	
	if remote_content_available():
		more_content_available = true
		dialog_text = DOWNLOAD_TEXT
		add_cancel_button("Cancel")
		ok_button_text = "Yes"

	return
	
# Private Methods


# remote_content_available()
# Check to see if any more remote content is available
#
# Parameters
#	None
# Return
#	true							Content available
#	false							No content available
#==
# We should have a valid content configuration file from the server
# See if any directories greater than our last one exist
# Return if they do
func remote_content_available() -> bool:
	print("Remote Content Available")
	print(content_config)
	var _ver = content_config.version
	var dirs = content_config.dirs
	return (dirs > Config.current_dir)


# fownload_content()
# Download additional content
#
# We need to download image files and their corresponding image_data.tres file
# from the remote http server. remote_content_available() downloaded remote 
# config.json file. This contains what directories are on the remote server.
# Each directory has image files and a file named image_data.tres (ImageData).
# We will loop through these directories to download the images. 
#
# But first, we need to get the contents of the image_data.tres files to get
# the image file names. We will build a Dictionary of the Dictionaries found 
# in the image_data.tres files.
#
# So, I can't figure out how to convert a string containing a .TRES Resource file
# into a Dictionary. The only way I can figure out is to store the image_data.tres
# files  on local media and do a resource load on the files to get the data. So, this
# method will fetch all the image_data.tres files available and write them to the
# corresponding content directories. As we write them, we will read them with
# resource loader and copy them to our structure controlling copying the image files.
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func download_content() -> void:
	var content_dir = DirAccess.open(Constant.CONTENT_DIR)
	for index in range(Config.current_dir + 1, content_config.dirs.size()):
		var dir = ("!03d") % index
		var req := HTTPRequest.new()
		add_child(req)
		var ret = req.request(Constant.CONTENT_SERVER + dir + "/image_data.tres")
		if ret != 0: 
			req.queue_free()
		else:	
	# Step 2
			var response = await http.request_completed
			if not(response[0] == 0 and response[1] == 200):
				req.queue_free()
			else:
		# Step 3
				var json := JSON.new()
				json.parse(response[3].get_string_from_utf8())
				content_config = json.get_data()
				json.queue_free()
				content_dir.make_dir("./" + dir)
				var file = FileAccess.open(Constant.CONTENT_DIR + dir + "/image_data.tres", FileAccess.WRITE)
				file.store_string(response[3])
				file.close()
		

# Subclasses


