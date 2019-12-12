extends Node2D

onready var bgm_1 = $AudioStreamPlayerOne
onready var bgm_2 = $AudioStreamPlayerTwo

func _ready():
	randomize()
	play_BGM()
	
func play_BGM():
	var a = rand_range(0, 100)
	if a < 50:
		bgm_1.play()
	else:
		bgm_2.play()

func _on_AudioStreamPlayerOne_finished():
	play_BGM()

func _on_AudioStreamPlayerTwo_finished():
	play_BGM()