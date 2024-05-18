class_name DownloadManager
extends CanvasLayer



#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

var downloaded_dirs: PackedStringArray

# private variables

# onready variables

@onready var content: Content = $Content
@onready var zip_manager: ZIPManager = $ZIPManager
@onready var http_manager: HTTPManager = $HTTPManager
@onready var loading_spinner = $LoadingSpinner

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
	loading_spinner.visible = false
	set_current_downloads()
	set_available_downloads()
	


# Built-in Signal Callbacks


# Custom Signal Callbacks

func download_clicked(index: int) -> void:
	var zippath: String = await download_zipfile(index)
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
# Step 3 - Turn off the default message
# Step 4 - Loop dirs in the config file
#	HTTPManager.we_have_http() will download the server config file
#	Create a button for the directory
#	Connect to our signal handler for when the button is pressed
# Step 5 - We're finished so turn off the spinner
func set_available_downloads() -> void:
	print("Downloaded dirs: ", downloaded_dirs)
# Step 1
	loading_spinner.visible = true	
# Step 2
	var container = $AvailableDownloads/MarginContainer/AvailableDownloadsVbox
	if not await http_manager.we_have_http():
		$AvailableDownloads/MarginContainer/CurrentDownloadLabel.visible = true
		loading_spinner.visible = false
		return
# Step 3	
	$AvailableDownloads/MarginContainer/CurrentDownloadLabel.visible = false
# Step 4
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
# Step 5
	loading_spinner.visible = false
	
# download_zipfile(index)
# Download specified ZIP file from the server
#
# Parameters
#	index: int						Number of the ZIP file
# Return
#	None
#==
# What the code is doing (steps)
func download_zipfile(index: int) -> String:
	var zipname = "%s%03d.zip" % [Constant.CONTENT_SERVER, index]
	var destname = "%s%03d.zip" % [Constant.CONTENT_DIR, index]
	
	loading_spinner.visible = true
	await http_manager.download_file(zipname, destname)

	loading_spinner.visible = false
	return destname
	
	
# Subclasses




