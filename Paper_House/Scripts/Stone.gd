extends StaticBody2D

onready var spr = $AnimatedSprite
onready var T_col = $T_CollisionShape2D

func change(newGenre):
	if newGenre: # platform
		spr.play("default", false)
		T_col.disabled = true
	else: # topdown
		spr.play("default", true)
		T_col.disabled = false
