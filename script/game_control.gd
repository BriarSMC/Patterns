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
@onready var quit_btn = $CanvasLayer/Control/QuitBtn
@onready var select_player_btn = $CanvasLayer/Control/PlayerSelection/VBoxContainer/SelectPlayerBtn
@onready var add_new_player = $CanvasLayer/Control/PlayerSelection/AddNewPlayer
@onready var player_name = $CanvasLayer/Control/PlayerSelection/AddNewPlayer/PlayerName
@onready var error_message = $CanvasLayer/Control/PlayerSelection/ErrorMessage
@onready var message = $CanvasLayer/Control/PlayerSelection/ErrorMessage/Message

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
# What the code is doing (steps)
# NOTE: Child must call super._ready() if it defines own _ready() method
func _ready() -> void:
	print("Player Data: ", Config.player_data)
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
	pass


# Built-in Signal Callbacks

func _on_new_player_btn_pressed():
	add_new_player.visible = true
	player_name.grab_focus()


func _on_add_new_player_confirmed():
	add_new_player.visible = false
	var name = player_name.text
	var name_key = name.to_upper()
	if Config.player_data.has(name_key):
		message.text = "Name aleady in use."
		error_message.visible = true
	else:	
		Config.player_data[name_key] = {"name": name, "current_picture": 0}
		Config.player_data_res.save()
		load_players()

	player_name.text = ""

# Custom Signal Callbacks


# Public Methods


# Private Methods

func load_players() -> void:
	select_player_btn.clear()
	for data in Config.player_data:
		print("Data: ", data)
		select_player_btn.add_item(Config.player_data[data].name)

# Subclasses


