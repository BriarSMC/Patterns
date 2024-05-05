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

# exports (The following properties must be set in the Inspector by the designer)

# public variables

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
# Add the Quit button
# Center the text in the panel
# Don't display as default
func _ready() -> void:
	# https://forum.godotengine.org/t/how-to-center-dialog-text-of-a-acceptdialog/16235/5
	get_child(1, true).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	visible = false


# Built-in Signal Callbacks

func _on_confirmed():
	get_parent().emit_signal("exit_game_requested")


# Custom Signal Callbacks


# Public Methods

# display_no_more_pictures()
# Display the PictureCompletedDialog, but change it to a
# No-More-Pictures-Left dialog
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func display_no_more_pictures() -> void:
	visible = true
	
	
# Private Methods


# Subclasses



