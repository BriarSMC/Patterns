class_name GameControl extends Node2D

#region Description
# This screen follows the splash screen. The game does a fade in using AnimationPlayer.
# 
# This screen has the following buttons:
#	o NewPlayerBtn - Add a new player to the player data
#	o SelectPlayerBtn - Select the player from the player data
#	o StartBtn - Start the game (switch to GamePlay)
#	o ExitBtn - Exit the game
#
# The game also has two popup windows:
#	o AddNewPlayer - Collect the player's data
#	o ErrorMessage - Display an error message
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

# onready variables

@onready var control = $CanvasLayer/Control
@onready var select_player_btn = $CanvasLayer/Control/PlayerSelection/PlayerSelectionVbox/SelectPlayerBtn
@onready var add_new_player = $CanvasLayer/Control/PlayerSelection/AddNewPlayer
@onready var player_name = $CanvasLayer/Control/PlayerSelection/AddNewPlayer/PlayerName
@onready var error_message = $CanvasLayer/Control/PlayerSelection/ErrorMessage
@onready var message = $CanvasLayer/Control/PlayerSelection/ErrorMessage/Message
@onready var animation_player = $AnimationPlayer
@onready var scene_control: SceneControl = $SceneControl
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
# Step 1
# 	If the player data structure is empty, then
# 		initialize the data dictionary with a blank last_player value
#		and save it
#	If the player data structure has one or less elements, then
#		hide the option button (Means the dictionary only has the last_player in it)
# 	Otherwise, load the players into the  option button
# Step 2
# 	Set up the add player popup window
# 	Load scenes we change to
func _ready() -> void:
# Step 1
	if Config.player_data.size() == 0:
		Config.player_data["last_player"] = ""
		Config.player_data["players"] = {}
		Config.player_data_res.save()
		
	if Config.player_data.size() <= 1:
		select_player_btn.visible = false
	else:
		load_players()
# Step 2
	add_new_player.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	add_new_player.ok_button_text = "Add"
	add_new_player.visible = false
	add_new_player.add_cancel_button("Cancel")
	add_new_player.register_text_enter(player_name)
	select_player_btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
# Step 3
	scene_control.load_scene(scene_control.scene.HELP)
	scene_control.load_scene(scene_control.scene.GAME_PLAY)


# Built-in Signal Callbacks

# Start the fadeout animation 
# We connect to the animation's finished signal to change to the next scene
func _on_start_btn_pressed():
	Music.game_start(false)
	Sfx.goto_game_play()
	animation_player.play("fade-out")

# Unceremoniously exit the game
func _on_quit_btn_pressed():
	get_tree().quit()


# Display help screen
func _on_help_btn_pressed():
	Sfx.ui_button()
	scene_control.change_scene(scene_control.scene.HELP, self)
	


# New player button pressed.
# Display the new player popup
func _on_new_player_btn_pressed():
	Sfx.ui_button()
	add_new_player.visible = true
	player_name.grab_focus()


# Add new player popup confirmed button pressed
# Add the new player to the player data
func _on_add_new_player_confirmed():
	Sfx.ui_button()
	add_new_player_confirmed()


# New player selected from list
func _on_select_player_btn_item_selected(index):
	Sfx.ui_button()
	Config.player_data["last_player"] = select_player_btn.get_item_text(index).to_upper()
	set_current_player(Config.player_data["last_player"])
	Config.player_data_res.save()
	
	
# Animation is finished.
# Change to GamePlay scene if 'fade-out'
func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'fade-out':
		scene_control.change_scene(scene_control.scene.GAME_PLAY, self)

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
# If player data is empty, then don't show SelectPlayerBtn
# Otherwise, display it and load its items
func load_players() -> void:
	if Config.player_data.is_empty():
		select_player_btn.visible = false
	else:
		select_player_btn.visible = true
		select_player_btn.clear()
		var idx := 0
		for name_key in Config.player_data.players:
			select_player_btn.add_item(Config.player_data.players[name_key].name)
			if name_key == Config.player_data["last_player"]:
				select_player_btn.select(idx)
				set_current_player(name_key)
			idx += 1


# add_new_player_confirmed()
# New player popup confirmed. Add the new player.
#
# Parameters
#	None
# Return
#	None
#==
# Step 1 - Turn off the popup
# Step 2 - Get the player name from the popup
# Step 3 - If the name already exists, then display error popup
# Step 4 - Otherwise, add the new player name and reload the player option button
# Step 5 - Clear the text field in the popup (VERY IMPORTANT DON'T FORGET)
func add_new_player_confirmed() -> void:
# Step 1
	add_new_player.visible = false
# Step 2
	var name_new = player_name.text
	var name_key = name_new.to_upper()
# Step 3
	if Config.player_data.has(name_key):
		message.text = "Name aleady in use."
		error_message.visible = true
# Step 4
	else:	
		Config.player_data["last_player"] = name_key
		Config.player_data["players"][name_key] = {"name": name_new, "current_dir": 0, 
			"current_picture": 0}
		Config.player_data_res.save()
		load_players()
# Step 5
	player_name.text = ""
	

# set_current_player(player)
# Set the current player
#
# Parameters
#	player: String					Name/Index of the current player
# Return
#	None
#==
# What the code is doing (steps)
func set_current_player(player) -> void:
	Config.current_player = player
	Config.current_player_data = Config.player_data.players[player]
	Config.current_picture = Config.current_player_data.current_picture


# Subclasses



