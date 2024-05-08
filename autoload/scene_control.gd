class_name SceneControl
extends Node



#region Description
# Because of a problem with Godot handling circular preloads (A preloads B, 
# which preloads A) we have this autoload module.
#
# In particular we are solving the problem of GameControl changing scenes to Help, then
# Help changing scenes to GameControl.
#
# So we will use the ResourceLoader to load scenes upon request and then change to them
# upon request. The calling scene needs to:
#
#	1) In _ready(): Call SceneControl.load_scene() with the scene index constant
#	2) Call SceneControl.change_scene() with the scene index constant and a ref to self
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

enum scene {GAME_CONTROL, HELP, GAME_PLAY}

# constants

# Scene paths
const GAME_CONTROL_SCENE := "res://scene/game_control.tscn"
const HELP_SCENE := "res://scene/help.tscn"
const GAME_PLAY_SCENE := "res://scene/game_play.tscn"

const SCENES := [GAME_CONTROL_SCENE, HELP_SCENE, GAME_PLAY_SCENE]

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

# onready variables

#endregion


# Virtual Godot methods


# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

# load_scene(s)
# Request us to load a scene
#
# Parameters
#	s: int							One of the Scene Index Constants above
# Return
#	None
#==
# Load resource path indicated by s
func load_scene(s: int) -> void:
	ResourceLoader.load_threaded_request(SCENES[s])
	

# change_scene(s, node)
# Change to the scene pointed to by s
#
# Parameters
#	s: int							One of the Scene Index Constants above
#	node: Node						reference to calling node (self)
# Return
#	None
#==
# Fetch the scene loaded by load_scene()
# Change to it
func change_scene(s: int, n: Node) -> void:
	var new_scene = ResourceLoader.load_threaded_get(SCENES[s])
	n.get_tree().change_scene_to_packed(new_scene)
	
	
# Private Methods


# Subclasses




