class_name DownloadManager
extends CanvasLayer



#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

const ERRMSG_NOHTTP = "Could not connect to Patterns server."
const ERRMSG_PLSCHK = "Please check your internet connection"
const ERRMSG_DLFAIL = "Could not download requested content"
const ERRMSG_CHKSRV = "Please check https://games.coghillclan.net/ for availability"

# exports (The following properties must be set in the Inspector by the designer)

# public variables

var downloaded_dirs: PackedStringArray

# private variables

# onready variables

@onready var content: Content = $Content
@onready var zip_manager: ZIPManager = $ZIPManager
@onready var http_manager: HTTPManager = $HTTPManager
@onready var loading_spinner = $LoadingSpinner
@onready var error_message = $ErrorMessage
@onready var message_1 = $ErrorMessage/MessagesVbox/Message1
@onready var message_2 = $ErrorMessage/MessagesVbox/Message2
@onready var scene_control = $SceneControl

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
func _ready():
	error_message.visible = false
	loading_spinner.visible = false
	set_current_downloads()
	set_available_downloads()
	scene_control.load_scene(scene_control.scene.GAME_PLAY)


# Built-in Signal Callbacks

func _on_continue_btn_pressed():
	scene_control.change_scene(scene_control.scene.GAME_PLAY, self)


func _on_quit_btn_pressed():
	get_tree().quit()
	
	
# Custom Signal Callbacks

func download_clicked(index: int) -> void:
	var zippath: String = await download_zipfile(index)
	if zippath == "":
		error_message.visible = true
		message_1.text = ERRMSG_DLFAIL
		message_2.text = ERRMSG_CHKSRV
		return
	zip_manager.unzip_content(zippath)
	set_current_downloads()
	set_available_downloads()

# Public Methods


# Private Methods

# set_current_downloads()
# Set contents of currently downloaded directories
#
# Parameters
#	None
# Return
#	None
#==
# Get the content directories array
# Get rid of the first element since that is the res:// entry
# If it's empty, then just display the 'none' label
# Otherwise, display the contents of the 
func set_current_downloads() -> void:
	var container = $CurrenbDownloads/MarginContainer/CurrentDownloadsVbox
	content.load_content_dirs()
	downloaded_dirs = content.content_dirs.duplicate()
	downloaded_dirs.remove_at(0)
	if downloaded_dirs.size() == 0:
		$CurrenbDownloads/MarginContainer/CurrentDownloadLabel.visible = true
	else:
		$CurrenbDownloads/MarginContainer/CurrentDownloadLabel.visible = false
		for o in container.get_children():
			o.queue_free()
		for d: int in downloaded_dirs.size():# String in downloaded_dirs:
			var label = Label.new()
			container.add_child(label)
			downloaded_dirs[d] = downloaded_dirs[d].get_slicec('/'.unicode_at(0), 3)
			label.text = downloaded_dirs[d]
			label.visible = true
			label.label_settings = $CurrenbDownloads/MarginContainer/CurrentDownloadLabel.label_settings


# set_available_downloads()
# Set contents of the available downloads
#
# Parameters
#	None
# Return
#	None
#==
# Step 1 - Turn on the loading spinner
# Step 2 - If we don't have an http connection to the server config file then
#	display the default message
#	turn off the spinner

# Step 3 - See if http downloaded the server config file
# Step 4 - Turn off the default message
# Step 5 - Loop dirs in the config file
#	HTTPManager.we_have_http() will download the server config file
#	Create a button for the directory
#	Connect to our signal handler for when the button is pressed
# Step 6 - We're finished so turn off the spinner
func set_available_downloads() -> void:
	print("Downloaded dirs: ", downloaded_dirs)
# Step 1
	loading_spinner.visible = true	
# Step 2
	var container = $AvailableDownloads/MarginContainer/AvailableDownloadsVbox
	if not await http_manager.we_have_http():
		#$AvailableDownloads/MarginContainer/CurrentDownloadLabel.visible = true
		loading_spinner.visible = false
		message_1.text = ERRMSG_NOHTTP
		message_2.text = ERRMSG_PLSCHK
		error_message.visible = true
		$AvailableDownloads.visible = false
		return
# Step 3	
	if http_manager.content_config.is_empty():
		loading_spinner.visible = false
		message_1.text = ERRMSG_DLFAIL
		message_2.text = ERRMSG_CHKSRV
		error_message.visible = true
		$AvailableDownloads.visible = false
		return
# Step 4
	$AvailableDownloads/MarginContainer/CurrentDownloadLabel.visible = false
# Step 5
	for o in container.get_children():
		o.queue_free()

	for c in http_manager.content_config.dirs:
		var btn = Button.new()
		var c_str = "%03d" % c
		container.add_child(btn)
		btn.custom_minimum_size.x = 200
		btn.text = "Download %s" % c_str
		btn.anchors_preset = 6
		if downloaded_dirs.find(c_str) != -1:
			btn.disabled = true
		
		btn.connect("pressed", download_clicked.bind(c))
# Step 6
	loading_spinner.visible = false
	
# download_zipfile(index)
# Download specified ZIP file from the server
#
# Parameters
#	index: int						Number of the ZIP file
# Return
#	String							The distination file path (blank if failed)
#==
# Step 1 - Create the source URL and destination path
# Step 2 - Start the spinner and get the file from server
#	if the download failed, then return an empty string
func download_zipfile(index: int) -> String:
# Step 1
	var zipname = "%s%s/%03d.zip" % [Constant.CONTENT_SERVER, Config.os_name, index]
	var destname = "%s%03d.zip" % [Constant.CONTENT_DIR, index]
# Step 2
	loading_spinner.visible = true
	if not await http_manager.download_file(zipname, destname):
		destname = ""
	loading_spinner.visible = false
	return destname
	
	
# Subclasses





