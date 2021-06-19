extends Node2D

onready var back = $Button_back
onready var quit = $Button_quit



func _on_Button_back_pressed():
	get_tree().change_scene("res://Levels/Start.tscn")


func _on_Button_quit_pressed():
	get_tree().quit()
