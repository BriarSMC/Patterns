class_name InputHandler
extends Node


@export var game_play: GamePlay

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
		game_play.emit_signal("exit_game_requested")
# Step 2		
	if (event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.pressed): 
		game_play.emit_signal("left_mouse_click_detected", event.position)

