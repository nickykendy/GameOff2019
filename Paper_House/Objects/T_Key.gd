extends StaticBody2D

onready var spr = $AnimatedSprite
onready var T_col = $T_CollisionShape2D

	
func is_picked():
	queue_free()
	
func change(newGenre):
	if newGenre: # platform
		spr.animation = "default"
		spr.frame = 0
		spr.playing = false
		spr.play("default", false)
		T_col.disabled = true
	else: # topdown
		spr.animation = "default"
		spr.frame = 3
		spr.playing = false
		spr.play("default", true)
		T_col.disabled = false

func _on_AnimatedSprite_animation_finished():
	if spr.animation == "default" and spr.frame == 0:
		spr.animation = "idle"
		spr.play()