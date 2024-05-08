extends Node2D

const GAME_CONTROL = "res://scene/game_control.tscn"


func _on_back_btn_pressed():
	Sfx.ui_button()
	get_tree().change_scene_to_file(GAME_CONTROL)
