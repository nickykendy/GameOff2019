extends Node2D

onready var start = $Button_Start
onready var quit = $Button_Exit

func _on_Button_Start_pressed():
	get_tree().change_scene("res://Levels/World.tscn")

func _on_Button_Exit_pressed():
	get_tree().quit()