class_name GameControl extends Node2D

#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

const GAME_PLAY = preload("res://scene/game_play.tscn")

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

# onready variables

@onready var control = $CanvasLayer/Control
@onready var select_player_btn = $CanvasLayer/Control/PlayerSelection/VBoxContainer/SelectPlayerBtn
@onready var add_new_player = $CanvasLayer/Control/PlayerSelection/AddNewPlayer
@onready var player_name = $CanvasLayer/Control/PlayerSelection/AddNewPlayer/PlayerName
@onready var error_message = $CanvasLayer/Control/PlayerSelection/ErrorMessage
@onready var message = $CanvasLayer/Control/PlayerSelection/ErrorMessage/Message
@onready var animation_player = $AnimationPlayer

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
# If the player data structure is empty, then hide the option button
# Otherwise, load it
# Set up the add player popup window
func _ready() -> void:
	if Config.player_data.size() == 0:
		select_player_btn.visible = false
	else:
		load_players()

	add_new_player.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	add_new_player.ok_button_text = "Add"
	add_new_player.visible = false
	add_new_player.add_cancel_button("Cancel")
	add_new_player.register_text_enter(player_name)


# _input(event)
# Called when input is available
#
# Parameters
#	event: InputEvent          	What input happened
# Return
#	None
#==
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("clear-player-data"):
		print("Clear Player Data")
		Config.player_data.clear()
		Config.player_data_res.save()
		load_players()

# Built-in Signal Callbacks


func _on_start_btn_pressed():
	animation_player.play("fade-out")


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_new_player_btn_pressed():
	add_new_player.visible = true
	player_name.grab_focus()


func _on_add_new_player_confirmed():
	add_new_player_confirmed()



func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'fade-out':
		get_tree().change_scene_to_packed(GAME_PLAY)

# Custom Signal Callbacks


# Public Methods


# Private Methods

# load_players()
# load player names into the option button
#
# Parameters
#	None
# Return
#	None
#==
# Clear the existing list
# Loop through the player data structure
#	Add player name to the option button list
func load_players() -> void:
	if Config.player_data.is_empty():
		select_player_btn.visible = false
	else:
		select_player_btn.visible = true
		select_player_btn.clear()
		for data in Config.player_data:
			select_player_btn.add_item(Config.player_data[data].name)


# add_new_player_confirmed()
# New player popup confirmed. Add the new player.
#
# Parameters
#	None
# Return
#	None
#==
# Turn off the popup
# Get the player name from the popup
# If the name already exists, then display error popup
# Otherwise, add the new player name and reload the player option button
# Clear the text field in the popup (VERY IMPORTANT DON'T FORGET)
func add_new_player_confirmed() -> void:
	add_new_player.visible = false
	var name_new = player_name.text
	var name_key = name_new.to_upper()
	if Config.player_data.has(name_key):
		message.text = "Name aleady in use."
		error_message.visible = true
	else:	
		Config.player_data[name_key] = {"name": name_new, "current_picture": 0}
		Config.player_data_res.save()
		load_players()

	player_name.text = ""
# Subclasses


