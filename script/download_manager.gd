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
	var container = $CurrenbDownloads/MarginContainer
	content.load_content_dirs()
	downloaded_dirs = content.content_dirs.duplicate()
	downloaded_dirs.remove_at(0)
	if downloaded_dirs.size() == 0:
		$CurrenbDownloads/MarginContainer/CurrentDownloadLabel.visible = true
	else:
		$CurrenbDownloads/MarginContainer/CurrentDownloadLabel.visible = false
		for d in downloaded_dirs:
			var label = Label.new()
			container.add_child(label)
			label.text = d
			label.visible = true


# set_available_downloads()
# Set contents of the available downloads
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func set_available_downloads() -> void:
	var container = $AvailableDownloads/MarginContainer
	if not await http_manager.we_have_http():
		$AvailableDownloads/MarginContainer/CurrentDownloadLabel.visible = true
		return
	$AvailableDownloads/MarginContainer/CurrentDownloadLabel.visible = false
	loading_spinner.visible = true	
	print(http_manager.content_config.version)
	for c in http_manager.content_config.dirs:
		print(c)
		var label = Label.new()
		container.add_child(label)
		label.text = str(c)
		label.visible = true
	loading_spinner.visible = false
# Subclasses



