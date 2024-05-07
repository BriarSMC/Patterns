extends Node2D

const GAME_CONTROL = preload("res://scene/game_control.tscn")


func _on_back_btn_pressed():
	Sfx.ui_button()
	get_tree().change_scene_to_packed(GAME_CONTROL)
