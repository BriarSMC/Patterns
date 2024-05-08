class_name SplashScreen
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

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

# onready variables

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
# What the code is doing (steps)
func _ready() -> void:
	Music.game_start()
	animation_player.play("fade-in")
	scene_control.load_scene(scene_control.scene.GAME_CONTROL)



# Built-in Signal Callbacks


func _on_animation_player_animation_finished(_anim_name):
	scene_control.change_scene(scene_control.scene.GAME_CONTROL, self)


# Custom Signal Callbacks


# Public Methods


# Private Methods


# Subclasses


