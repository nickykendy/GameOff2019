extends Area2D

onready var spr = $AnimatedSprite
onready var P_col = $P_CollisionShape2D

var isCracked = false

func change(newGenre):
	if newGenre: # platform
		if isCracked:
			spr.play("op", false)
		else:
			spr.play("cl", false)
		P_col.set_deferred("disabled", false)
#		P_col.disabled = false
	else: # topdown
		if isCracked:
			spr.play("op", true)
		else:
			spr.play("cl", true)
		P_col.set_deferred("disabled", true)
#		P_col.disabled = true

func is_cracking():
	if spr.animation != "op":
		spr.animation = "op"
		spr.frame = 3
		isCracked = true
