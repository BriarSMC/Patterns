class_name GameStart
extends Node2D


#region Description
# This is the main node/entry point for the game
#
# This is essencially just a UI for setting up and starting the game.
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

const GAME_CONTROL = preload("res://scene/game_control.tscn")

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

# onready variables

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
# What the code is doing (steps)
func _ready() -> void:
	animation_player.play("fade-in")
	pass



# Built-in Signal Callbacks


func _on_animation_player_animation_finished(_anim_name):
	get_tree().change_scene_to_packed(GAME_CONTROL)


# Custom Signal Callbacks


# Public Methods


# Private Methods


# Subclasses


