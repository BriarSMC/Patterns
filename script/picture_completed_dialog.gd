class_name PicturesCompletedDialog
extends AcceptDialog

#region Description
# This dialog popup is used both when the player has found all the patterns in the 
# picture.
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

var picture_completed_quit_button: Button
var more_pictures := true

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
	picture_completed_quit_button = add_cancel_button("Quit")	
	# https://forum.godotengine.org/t/how-to-center-dialog-text-of-a-acceptdialog/16235/5
	get_child(1, true).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	visible = false
	more_pictures = true


# Built-in Signal Callbacks

func _on_confirmed():
	if more_pictures:
		get_parent().emit_signal("picture_complete_dialog_closed", "next")
		visible = false


func _on_canceled():
	get_parent().emit_signal("picture_complete_dialog_closed", "quit")
	visible = false

# Custom Signal Callbacks


# Public Methods

# next_picture(time_elapsed)
# Display dialog box for going to next picture
#
# Parameters
#	time_elapsed: float				Time elapsed
# Return
#	None
#==
# Break out time elapsed into hours, minutes, seconds
# Display string with these elements
func next_picture(time_elapsed: float) -> void:
	var hours = time_elapsed / 3600
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	var text = "You found all patterns in %02d:%02d:%02d" % [hours, minutes, seconds]

	dialog_text = text
	visible = true

	
# Private Methods


# Subclasses



