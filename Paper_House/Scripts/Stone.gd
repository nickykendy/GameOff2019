extends StaticBody2D

onready var spr : = $AnimatedSprite
onready var T_col : = $T_CollisionShape2D
onready var P_col : = $P_CollisionShape2D

func change(newGenre : bool) -> void:
	if newGenre: # platform
		spr.play("default", false)
		P_col.set_deferred("disabled", false)
		T_col.set_deferred("disabled", true)
#		P_col.disabled = false
#		T_col.disabled = true
	else: # topdown
		spr.play("default", true)
		P_col.set_deferred("disabled", true)
		T_col.set_deferred("disabled", false)
#		P_col.disabled = true
#		T_col.disabled = false
