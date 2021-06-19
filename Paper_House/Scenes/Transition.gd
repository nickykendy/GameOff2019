extends ColorRect

onready var anim : = $AnimationPlayer

var next_scene : String

signal fade_complete


# true: in, false: out
func fade(value : bool) -> void:
	if value:
		anim.play("FadeIn")
	else:
		anim.play("FadeOut")


func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	if anim_name == "FadeIn":
		get_tree().change_scene(next_scene)
	
	emit_signal("fade_complete")
