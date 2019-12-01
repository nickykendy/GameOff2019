extends Node2D

onready var start = $Button_Start
onready var quit = $Button_Exit
export var next_scene = "res://Levels/Level_1.tscn"

func _on_Button_Start_pressed():
	get_tree().change_scene(next_scene)

func _on_Button_Exit_pressed():
	get_tree().quit()